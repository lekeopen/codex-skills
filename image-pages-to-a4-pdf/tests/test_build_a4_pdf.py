"""Unit tests for the deterministic A4 image-PDF builder."""

from __future__ import annotations

import hashlib
import io
import os
import subprocess
import sys
import tempfile
import unittest
from contextlib import redirect_stderr
from pathlib import Path
from unittest.mock import patch

from PIL import Image


SCRIPT_DIR = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(SCRIPT_DIR))

from build_a4_pdf import (  # noqa: E402
    A4_300_DPI,
    add_ocr_layer,
    build_image_pdf,
    check_ocr_dependencies,
    collect_inputs,
    load_manifest,
    main,
    prepare_page,
)


class A4PdfBuilderTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary_directory.name)
        self.images = self.root / "images"
        self.images.mkdir()

    def tearDown(self) -> None:
        self.temporary_directory.cleanup()

    def make_image(self, name: str, size: tuple[int, int] = (90, 60)) -> Path:
        path = self.images / name
        Image.new("RGB", size, "navy").save(path)
        return path

    def test_collect_inputs_sorts_directory_entries_case_insensitively(self) -> None:
        page_b = self.make_image("b-page.PNG")
        page_a = self.make_image("A-page.jpg")
        self.make_image("ignored.jpeg")
        (self.images / "notes.txt").write_text("not an image", encoding="utf-8")

        inputs = collect_inputs([self.images])

        self.assertEqual(inputs, [page_a, page_b, self.images / "ignored.jpeg"])

    def test_collect_inputs_breaks_casefold_ties_by_original_filename(self) -> None:
        sharp_s = self.root / "sharp-s" / "ß.png"
        double_s = self.root / "double-s" / "ss.png"
        sharp_s.parent.mkdir()
        double_s.parent.mkdir()
        Image.new("RGB", (90, 60), "navy").save(sharp_s)
        Image.new("RGB", (90, 60), "navy").save(double_s)
        original_iterdir = Path.iterdir

        def tied_entries(path: Path):
            if path == self.images:
                return iter([sharp_s, double_s])
            return original_iterdir(path)

        with patch.object(Path, "iterdir", tied_entries):
            inputs = collect_inputs([self.images])

        self.assertEqual(inputs, [double_s, sharp_s])

    def test_manifest_preserves_its_exact_explicit_order(self) -> None:
        first = self.make_image("first.png")
        second = self.make_image("second.png")
        inputs = collect_inputs([self.images])
        manifest = self.root / "order.txt"
        manifest.write_text("images/second.png\nimages/first.png\n", encoding="utf-8")

        ordered = load_manifest(manifest, inputs)

        self.assertEqual(ordered, [second, first])

    def test_manifest_rejects_missing_duplicate_and_foreign_entries(self) -> None:
        self.make_image("first.png")
        self.make_image("second.png")
        inputs = collect_inputs([self.images])
        cases = {
            "missing.txt": "images/first.png\n",
            "duplicate.txt": "images/first.png\nimages/first.png\nimages/second.png\n",
            "foreign.txt": "images/first.png\nimages/second.png\nimages/not-discovered.png\n",
        }

        for filename, contents in cases.items():
            with self.subTest(filename=filename):
                manifest = self.root / filename
                manifest.write_text(contents, encoding="utf-8")
                with self.assertRaises(ValueError):
                    load_manifest(manifest, inputs)

    def test_prepare_page_produces_centered_a4_canvas_without_changing_source(self) -> None:
        source = self.make_image("source.png", (180, 60))
        original_hash = hashlib.sha256(source.read_bytes()).hexdigest()

        page = prepare_page(source, contrast=1.04, sharpness=1.35)

        self.assertEqual(page.size, A4_300_DPI)
        self.assertEqual(page.getpixel((0, 0)), (255, 255, 255))
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), original_hash)

    def test_prepare_page_composites_transparent_png_pixels_onto_white(self) -> None:
        source = self.images / "transparent.png"
        Image.new("RGBA", (60, 60), (0, 0, 0, 0)).save(source)

        page = prepare_page(source, contrast=1.0, sharpness=1.0)

        self.assertEqual(
            page.getpixel((page.width // 2, page.height // 2)),
            (255, 255, 255),
        )

    def test_prepare_page_composites_grayscale_trns_png_onto_white(self) -> None:
        source = self.images / "grayscale-trns.png"
        image = Image.new("L", (60, 60), 128)
        image.paste(0, (20, 20, 40, 40))
        image.save(source, transparency=0)
        with Image.open(source) as reopened:
            self.assertEqual(reopened.mode, "L")
            self.assertIn("transparency", reopened.info)

        page = prepare_page(source, contrast=1.0, sharpness=1.0)

        self.assertEqual(
            page.getpixel((page.width // 2, page.height // 2)),
            (255, 255, 255),
        )

    def test_prepare_page_composites_rgb_trns_png_onto_white(self) -> None:
        source = self.images / "rgb-trns.png"
        transparent_color = (0, 255, 0)
        image = Image.new("RGB", (60, 60), "navy")
        image.paste(transparent_color, (20, 20, 40, 40))
        image.save(source, transparency=transparent_color)
        with Image.open(source) as reopened:
            self.assertEqual(reopened.mode, "RGB")
            self.assertIn("transparency", reopened.info)

        page = prepare_page(source, contrast=1.0, sharpness=1.0)

        self.assertEqual(
            page.getpixel((page.width // 2, page.height // 2)),
            (255, 255, 255),
        )

    def test_collect_inputs_rejects_unsupported_files(self) -> None:
        unsupported = self.root / "scan.tiff"
        unsupported.write_bytes(b"not a supported scan")

        with self.assertRaises(ValueError):
            collect_inputs([unsupported])

    def test_build_image_pdf_refuses_existing_output_without_overwrite(self) -> None:
        source = self.make_image("page.png")
        output = self.root / "output" / "pages.pdf"
        output.parent.mkdir()
        output.write_bytes(b"existing PDF")

        with self.assertRaises(FileExistsError):
            build_image_pdf([source], output, overwrite=False, contrast=1.04, sharpness=1.35)

    def test_build_image_pdf_keeps_existing_output_when_generation_fails(self) -> None:
        source = self.make_image("page.png")
        output = self.root / "output" / "pages.pdf"
        output.parent.mkdir()
        output.write_bytes(b"existing PDF")
        saved_paths: list[Path] = []

        def fail_save(
            _image: Image.Image,
            destination: object,
            *_args: object,
            **_kwargs: object,
        ) -> None:
            saved_paths.append(Path(destination))
            raise OSError("simulated PDF generation failure")

        with patch.object(Image.Image, "save", autospec=True, side_effect=fail_save):
            with self.assertRaisesRegex(OSError, "simulated PDF generation failure"):
                build_image_pdf(
                    [source], output, overwrite=True, contrast=1.04, sharpness=1.35
                )

        self.assertEqual(output.read_bytes(), b"existing PDF")
        self.assertEqual(len(saved_paths), 1)
        self.assertEqual(saved_paths[0].parent, output.parent)
        self.assertNotEqual(saved_paths[0], output)
        self.assertFalse(saved_paths[0].exists())

    def test_build_image_pdf_refuses_late_collision_without_overwrite(self) -> None:
        source = self.make_image("page.png")
        output = self.root / "output" / "pages.pdf"
        output.parent.mkdir()
        original_save = Image.Image.save
        saved_paths: list[Path] = []

        def save_with_late_collision(
            image: Image.Image,
            destination: object,
            *args: object,
            **kwargs: object,
        ) -> None:
            saved_paths.append(Path(destination))
            output.write_bytes(b"late PDF")
            original_save(image, destination, *args, **kwargs)

        with patch.object(
            Image.Image,
            "save",
            autospec=True,
            side_effect=save_with_late_collision,
        ):
            with self.assertRaises(FileExistsError):
                build_image_pdf(
                    [source], output, overwrite=False, contrast=1.04, sharpness=1.35
                )

        self.assertEqual(output.read_bytes(), b"late PDF")
        self.assertEqual(len(saved_paths), 1)
        self.assertEqual(saved_paths[0].parent, output.parent)
        self.assertNotEqual(saved_paths[0], output)
        self.assertFalse(saved_paths[0].exists())

    def test_build_image_pdf_never_allows_output_to_replace_an_input(self) -> None:
        source = self.make_image("page.png")

        with self.assertRaises(ValueError):
            build_image_pdf([source], source, overwrite=True, contrast=1.04, sharpness=1.35)

    def test_build_image_pdf_rejects_symlink_output_alias_to_input(self) -> None:
        source = self.make_image("page.png")
        output_alias = self.root / "page-output.pdf"
        try:
            output_alias.symlink_to(source)
        except OSError as error:
            self.skipTest(f"Symlinks are not available: {error}")

        with self.assertRaises(ValueError):
            build_image_pdf(
                [source], output_alias, overwrite=True, contrast=1.04, sharpness=1.35
            )

    def test_build_image_pdf_rejects_hard_link_output_alias_to_input(self) -> None:
        source = self.make_image("page.png")
        output_alias = self.root / "page-output.pdf"
        try:
            os.link(source, output_alias)
        except OSError as error:
            self.skipTest(f"Hard links are not available: {error}")

        with self.assertRaises(ValueError):
            build_image_pdf(
                [source], output_alias, overwrite=True, contrast=1.04, sharpness=1.35
            )

    def test_build_image_pdf_rejects_dangling_output_symlink_without_overwrite(self) -> None:
        source = self.make_image("page.png")
        output = self.root / "output.pdf"
        target = self.root / "missing-target.pdf"
        try:
            output.symlink_to(target)
        except OSError as error:
            self.skipTest(f"Symlinks are not available: {error}")

        with self.assertRaises(FileExistsError):
            build_image_pdf([source], output, overwrite=False, contrast=1.04, sharpness=1.35)
        self.assertFalse(target.exists())

    def test_build_image_pdf_rejects_dangling_output_symlink_with_overwrite(self) -> None:
        source = self.make_image("page.png")
        output = self.root / "output.pdf"
        target = self.root / "missing-target.pdf"
        try:
            output.symlink_to(target)
        except OSError as error:
            self.skipTest(f"Symlinks are not available: {error}")

        with self.assertRaises(FileExistsError):
            build_image_pdf([source], output, overwrite=True, contrast=1.04, sharpness=1.35)
        self.assertFalse(target.exists())

    def test_check_ocr_dependencies_explains_how_to_install_tesseract(self) -> None:
        with patch("build_a4_pdf.shutil.which", return_value=None):
            with self.assertRaisesRegex(RuntimeError, "(?s)Tesseract.*brew install tesseract"):
                check_ocr_dependencies("chi_sim+eng")

    def test_check_ocr_dependencies_explains_how_to_install_ocrmypdf(self) -> None:
        with patch(
            "build_a4_pdf.shutil.which",
            side_effect=lambda executable: "/usr/bin/tesseract"
            if executable == "tesseract"
            else None,
        ):
            with self.assertRaisesRegex(RuntimeError, "(?s)OCRmyPDF.*apt-get install.*ocrmypdf"):
                check_ocr_dependencies("chi_sim+eng")

    def test_check_ocr_dependencies_reports_missing_language_pack(self) -> None:
        language_listing = "List of available languages in /usr/share/tessdata/ (2):\neng\nosd\n"
        with (
            patch("build_a4_pdf.shutil.which", side_effect=["/usr/bin/tesseract", "/usr/bin/ocrmypdf"]),
            patch(
                "build_a4_pdf.subprocess.run",
                return_value=subprocess.CompletedProcess(
                    ["tesseract", "--list-langs"], 0, stdout=language_listing
                ),
            ),
        ):
            with self.assertRaisesRegex(RuntimeError, "(?s)chi_sim.*tesseract-lang"):
                check_ocr_dependencies("chi_sim+eng")

    def test_add_ocr_layer_invokes_ocrmypdf_with_required_options_and_publishes_after_success(self) -> None:
        image_pdf = self.root / "image-only.pdf"
        image_pdf.write_bytes(b"image PDF")
        output = self.root / "output" / "searchable.pdf"
        commands: list[list[str]] = []

        def complete_ocr(
            command: list[str], **_kwargs: object
        ) -> subprocess.CompletedProcess[str]:
            commands.append(command)
            Path(command[-1]).write_bytes(b"searchable PDF")
            return subprocess.CompletedProcess(command, 0)

        def run_command(
            command: list[str], **kwargs: object
        ) -> subprocess.CompletedProcess[str]:
            if command[:2] == ["/usr/bin/tesseract", "--list-langs"]:
                return subprocess.CompletedProcess(command, 0, stdout="chi_sim\neng\n")
            return complete_ocr(command, **kwargs)

        with (
            patch("build_a4_pdf.shutil.which", side_effect=["/usr/bin/tesseract", "/usr/bin/ocrmypdf"]),
            patch(
                "build_a4_pdf.subprocess.run",
                side_effect=run_command,
            ),
        ):
            add_ocr_layer(image_pdf, output, "chi_sim+eng", overwrite=False)

        self.assertEqual(output.read_bytes(), b"searchable PDF")
        temporary_output = Path(commands[0][-1])
        self.assertEqual(temporary_output.parent, output.parent)
        self.assertNotEqual(temporary_output, output)
        self.assertEqual(
            commands[0][:-1],
            [
                "/usr/bin/ocrmypdf",
                "--force-ocr",
                "--deskew",
                "--optimize",
                "1",
                "--language",
                "chi_sim+eng",
                str(image_pdf),
            ],
        )

    def test_add_ocr_layer_keeps_existing_output_when_ocr_fails(self) -> None:
        image_pdf = self.root / "image-only.pdf"
        image_pdf.write_bytes(b"image PDF")
        output = self.root / "searchable.pdf"
        output.write_bytes(b"existing PDF")

        with (
            patch("build_a4_pdf.shutil.which", side_effect=["/usr/bin/tesseract", "/usr/bin/ocrmypdf"]),
            patch(
                "build_a4_pdf.subprocess.run",
                side_effect=[
                    subprocess.CompletedProcess(
                        ["tesseract", "--list-langs"], 0, stdout="chi_sim\neng\n"
                    ),
                    subprocess.CalledProcessError(1, ["ocrmypdf"]),
                ],
            ),
        ):
            with self.assertRaises(subprocess.CalledProcessError):
                add_ocr_layer(image_pdf, output, "chi_sim+eng", overwrite=True)

        self.assertEqual(output.read_bytes(), b"existing PDF")

    def test_add_ocr_layer_refuses_late_collision_without_overwrite(self) -> None:
        image_pdf = self.root / "image-only.pdf"
        image_pdf.write_bytes(b"image PDF")
        output = self.root / "output" / "searchable.pdf"

        def run_command(
            command: list[str], **_kwargs: object
        ) -> subprocess.CompletedProcess[str]:
            if command[:2] == ["/usr/bin/tesseract", "--list-langs"]:
                return subprocess.CompletedProcess(command, 0, stdout="chi_sim\neng\n")
            Path(command[-1]).write_bytes(b"searchable PDF")
            output.write_bytes(b"late PDF")
            return subprocess.CompletedProcess(command, 0)

        with (
            patch(
                "build_a4_pdf.shutil.which",
                side_effect=["/usr/bin/tesseract", "/usr/bin/ocrmypdf"],
            ),
            patch("build_a4_pdf.subprocess.run", side_effect=run_command),
        ):
            with self.assertRaises(FileExistsError):
                add_ocr_layer(image_pdf, output, "chi_sim+eng", overwrite=False)

        self.assertEqual(output.read_bytes(), b"late PDF")

    def test_add_ocr_layer_never_allows_output_to_replace_its_source_pdf(self) -> None:
        image_pdf = self.root / "image-only.pdf"
        image_pdf.write_bytes(b"image PDF")

        with (
            patch("build_a4_pdf.shutil.which", side_effect=["/usr/bin/tesseract", "/usr/bin/ocrmypdf"]),
            patch(
                "build_a4_pdf.subprocess.run",
                return_value=subprocess.CompletedProcess(
                    ["tesseract", "--list-langs"], 0, stdout="chi_sim\neng\n"
                ),
            ),
        ):
            with self.assertRaises(ValueError):
                add_ocr_layer(image_pdf, image_pdf, "chi_sim+eng", overwrite=True)

        self.assertEqual(image_pdf.read_bytes(), b"image PDF")

    def test_no_ocr_does_not_check_ocr_dependencies(self) -> None:
        source = self.make_image("page.png")
        output = self.root / "output" / "pages.pdf"

        with (
            patch.object(
                sys,
                "argv",
                [
                    "build_a4_pdf.py",
                    str(source),
                    "--output",
                    str(output),
                    "--no-ocr",
                ],
            ),
            patch("build_a4_pdf.shutil.which") as which,
        ):
            main()

        which.assert_not_called()
        self.assertTrue(output.is_file())

    def test_main_orchestrates_ocr_and_returns_success(self) -> None:
        source = self.make_image("page.png")
        output = self.root / "output" / "searchable.pdf"
        ocr_commands: list[list[str]] = []

        def run_command(
            command: list[str], **_kwargs: object
        ) -> subprocess.CompletedProcess[str]:
            if command[:2] == ["/usr/bin/tesseract", "--list-langs"]:
                return subprocess.CompletedProcess(command, 0, stdout="chi_sim\neng\n")
            ocr_commands.append(command)
            self.assertTrue(Path(command[-2]).is_file())
            Path(command[-1]).write_bytes(b"searchable PDF")
            return subprocess.CompletedProcess(command, 0)

        with (
            patch.object(
                sys,
                "argv",
                [
                    "build_a4_pdf.py",
                    str(source),
                    "--output",
                    str(output),
                    "--ocr",
                ],
            ),
            patch(
                "build_a4_pdf.shutil.which",
                side_effect=["/usr/bin/tesseract", "/usr/bin/ocrmypdf"],
            ),
            patch("build_a4_pdf.subprocess.run", side_effect=run_command),
        ):
            result = main()

        self.assertEqual(result, 0)
        self.assertEqual(output.read_bytes(), b"searchable PDF")
        self.assertEqual(len(ocr_commands), 1)
        self.assertNotEqual(ocr_commands[0][-1], str(output))

    def test_main_reports_expected_failures_without_traceback(self) -> None:
        expected_failures = (
            ValueError("bad input"),
            FileNotFoundError("missing manifest"),
            FileExistsError("output exists"),
            RuntimeError("missing dependency"),
            subprocess.CalledProcessError(7, ["ocrmypdf"]),
            OSError("disk failure"),
        )

        for error in expected_failures:
            with self.subTest(error=type(error).__name__):
                stderr = io.StringIO()
                with (
                    patch.object(
                        sys,
                        "argv",
                        [
                            "build_a4_pdf.py",
                            "missing.png",
                            "--output",
                            str(self.root / "output.pdf"),
                            "--no-ocr",
                        ],
                    ),
                    patch("build_a4_pdf.collect_inputs", side_effect=error),
                    redirect_stderr(stderr),
                ):
                    result = main()

                diagnostic = stderr.getvalue()
                self.assertEqual(result, 1)
                self.assertTrue(diagnostic.startswith("error: "), diagnostic)
                self.assertNotIn("Traceback", diagnostic)
                self.assertEqual(len(diagnostic.strip().splitlines()), 1)

    def test_readme_documents_required_and_optional_dependencies(self) -> None:
        readme = (Path(__file__).resolve().parents[2] / "README.md").read_text(
            encoding="utf-8"
        )

        for required_text in (
            "Python 3",
            "Pillow",
            "`pypdf`",
            "Poppler",
            "`pdfinfo`",
            "`pdftoppm`",
            "Tesseract",
            "OCRmyPDF",
            "user-installed",
            "never install dependencies automatically",
        ):
            with self.subTest(required_text=required_text):
                self.assertIn(required_text, readme)

    def test_skill_documents_dependency_checks_per_page_validation_and_memory_limit(
        self,
    ) -> None:
        skill = (Path(__file__).resolve().parents[1] / "SKILL.md").read_text(
            encoding="utf-8"
        )

        for required_text in (
            "python3 -c 'from PIL import Image'",
            "python3 -c 'from pypdf import PdfReader'",
            "command -v pdfinfo",
            "command -v pdftoppm",
            "python3 -m pip install Pillow pypdf",
            "brew install poppler",
            'pdfinfo -f 1 -l "$PAGE_COUNT"',
            "holds every prepared full-resolution page in memory",
            "split the input into smaller batches",
            "ordered manifest chunks",
            "distinct batch PDFs",
            "merge them in batch order with locally installed `pypdf`",
            "repeat the all-page structural and rendered verification",
            "pass only that chunk's image paths as inputs",
            "from pypdf import PdfWriter",
            'with output.open("xb") as destination',
        ):
            with self.subTest(required_text=required_text):
                self.assertIn(required_text, skill)


if __name__ == "__main__":
    unittest.main()
