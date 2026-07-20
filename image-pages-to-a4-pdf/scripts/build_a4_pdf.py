#!/usr/bin/env python3
"""Build a 300 DPI A4 PDF from ordered JPG, JPEG, or PNG page images."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image, ImageEnhance, ImageOps


A4_300_DPI = (2480, 3508)
SUPPORTED_SUFFIXES = {".jpg", ".jpeg", ".png"}
OCR_INSTALL_INSTRUCTIONS = "\n".join(
    (
        "macOS: brew install tesseract tesseract-lang ocrmypdf",
        "Ubuntu: sudo apt-get install tesseract-ocr tesseract-ocr-chi-sim "
        "tesseract-ocr-eng ocrmypdf",
    )
)
CLI_ERROR_EXIT = 1
EXPECTED_CLI_ERRORS = (
    ValueError,
    FileNotFoundError,
    FileExistsError,
    RuntimeError,
    subprocess.CalledProcessError,
    OSError,
)


def collect_inputs(paths: list[Path]) -> list[Path]:
    """Expand image files and directories into deterministic input paths."""
    inputs: list[Path] = []
    for path in paths:
        if path.is_dir():
            inputs.extend(
                sorted(
                    (
                        entry
                        for entry in path.iterdir()
                        if entry.is_file() and entry.suffix.casefold() in SUPPORTED_SUFFIXES
                    ),
                    key=lambda entry: (entry.name.casefold(), entry.name),
                )
            )
            continue
        if not path.is_file():
            raise ValueError(f"Input does not exist or is not a file: {path}")
        if path.suffix.casefold() not in SUPPORTED_SUFFIXES:
            raise ValueError(f"Unsupported image file: {path}")
        inputs.append(path)

    if not inputs:
        raise ValueError("No supported image files found")
    return inputs


def load_manifest(path: Path, inputs: list[Path]) -> list[Path]:
    """Load an explicit order manifest which lists every discovered input once."""
    discovered = {input_path.resolve(): input_path for input_path in inputs}
    entries = [
        line.strip()
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    ordered = [(path.parent / entry).resolve() for entry in entries]

    if len(ordered) != len(set(ordered)):
        raise ValueError("Manifest contains duplicate entries")
    if set(ordered) != set(discovered):
        raise ValueError("Manifest must contain every discovered input exactly once")
    return [discovered[entry] for entry in ordered]


def prepare_page(
    path: Path, contrast: float = 1.04, sharpness: float = 1.35
) -> Image.Image:
    """Convert one source image into a centered, uncropped A4 RGB canvas."""
    with Image.open(path) as image:
        oriented = ImageOps.exif_transpose(image)
        has_alpha = oriented.mode in {"RGBA", "LA"} or "transparency" in oriented.info
        if has_alpha:
            background = Image.new("RGBA", oriented.size, "white")
            source = Image.alpha_composite(
                background, oriented.convert("RGBA")
            ).convert("RGB")
        else:
            source = oriented.convert("RGB")
        source = ImageEnhance.Contrast(source).enhance(contrast)
        resized = ImageOps.contain(source, A4_300_DPI, Image.Resampling.LANCZOS)
        resized = ImageEnhance.Sharpness(resized).enhance(sharpness)
    page = Image.new("RGB", A4_300_DPI, "white")
    page.paste(resized, ((page.width - resized.width) // 2, (page.height - resized.height) // 2))
    return page


def validate_output_path(inputs: list[Path], output: Path, overwrite: bool) -> None:
    """Ensure an output is safe to create without replacing any source image."""
    resolved_output = output.resolve()
    if any(resolved_output == input_path.resolve() for input_path in inputs):
        raise ValueError("Output path must not replace an input image")
    if os.path.lexists(output) and output.is_symlink() and not output.exists():
        raise FileExistsError(f"Output is a dangling symlink: {output}")
    for input_path in inputs:
        try:
            if output.samefile(input_path):
                raise ValueError("Output path must not replace an input image")
        except FileNotFoundError:
            pass
    if output.exists() and not overwrite:
        raise FileExistsError(f"Output already exists: {output}")


def _new_sibling_temporary_path(output: Path, label: str) -> Path:
    """Reserve a unique temporary PDF path beside the final output."""
    with tempfile.NamedTemporaryFile(
        prefix=f".{output.stem}-{label}-",
        suffix=output.suffix or ".pdf",
        dir=output.parent,
        delete=False,
    ) as temporary_file:
        return Path(temporary_file.name)


def _publish_staged_pdf(
    staged_output: Path,
    output: Path,
    protected_inputs: list[Path],
    overwrite: bool,
) -> None:
    """Publish a complete sibling file while preserving no-clobber semantics."""
    validate_output_path(protected_inputs, output, overwrite)
    if overwrite:
        staged_output.replace(output)
        return

    try:
        os.link(staged_output, output)
    except FileExistsError as error:
        raise FileExistsError(f"Output already exists: {output}") from error
    staged_output.unlink()


def build_image_pdf(
    inputs: list[Path],
    output: Path,
    overwrite: bool,
    contrast: float,
    sharpness: float,
) -> None:
    """Write the input pages to an A4 PDF, protecting an existing output by default."""
    if not inputs:
        raise ValueError("At least one input image is required")
    validate_output_path(inputs, output, overwrite)

    output.parent.mkdir(parents=True, exist_ok=True)
    pages = [prepare_page(path, contrast, sharpness) for path in inputs]
    staged_output: Path | None = None
    try:
        staged_output = _new_sibling_temporary_path(output, "image")
        pages[0].save(
            staged_output,
            "PDF",
            resolution=300.0,
            save_all=True,
            append_images=pages[1:],
        )
        _publish_staged_pdf(staged_output, output, inputs, overwrite)
    finally:
        if staged_output is not None:
            staged_output.unlink(missing_ok=True)
        for page in pages:
            page.close()


def check_ocr_dependencies(languages: str) -> tuple[str, str]:
    """Return the OCR executables after verifying requested language packs exist."""
    tesseract = shutil.which("tesseract")
    if not tesseract:
        raise RuntimeError(
            "Tesseract is required for OCR but was not found on PATH.\n"
            f"{OCR_INSTALL_INSTRUCTIONS}"
        )
    ocrmypdf = shutil.which("ocrmypdf")
    if not ocrmypdf:
        raise RuntimeError(
            "OCRmyPDF is required for OCR but was not found on PATH.\n"
            f"{OCR_INSTALL_INSTRUCTIONS}"
        )

    requested_languages = [language.strip() for language in languages.split("+") if language.strip()]
    if not requested_languages:
        raise ValueError("At least one OCR language must be specified")
    try:
        result = subprocess.run(
            [tesseract, "--list-langs"],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as error:
        raise RuntimeError(
            "Tesseract could not list installed language packs.\n"
            f"{OCR_INSTALL_INSTRUCTIONS}"
        ) from error
    available_languages = {line.strip() for line in result.stdout.splitlines() if line.strip()}
    missing_languages = [
        language for language in requested_languages if language not in available_languages
    ]
    if missing_languages:
        raise RuntimeError(
            "Tesseract language pack(s) not installed: "
            f"{', '.join(missing_languages)}.\n{OCR_INSTALL_INSTRUCTIONS}"
        )
    return tesseract, ocrmypdf


def _publish_ocr_result(
    image_pdf: Path,
    output: Path,
    languages: str,
    overwrite: bool,
    ocrmypdf: str,
) -> None:
    """Run OCR into a sibling temporary directory, then publish it on success."""
    validate_output_path([image_pdf], output, overwrite)
    output.parent.mkdir(parents=True, exist_ok=True)
    temporary_output = _new_sibling_temporary_path(output, "ocr")
    temporary_output.unlink()
    try:
        subprocess.run(
            [
                ocrmypdf,
                "--force-ocr",
                "--deskew",
                "--optimize",
                "1",
                "--language",
                languages,
                str(image_pdf),
                str(temporary_output),
            ],
            check=True,
        )
        _publish_staged_pdf(temporary_output, output, [image_pdf], overwrite)
    finally:
        temporary_output.unlink(missing_ok=True)


def add_ocr_layer(image_pdf: Path, output: Path, languages: str, overwrite: bool) -> None:
    """Create a searchable PDF without publishing a partial result on OCR failure."""
    _, ocrmypdf = check_ocr_dependencies(languages)
    _publish_ocr_result(image_pdf, output, languages, overwrite, ocrmypdf)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("inputs", nargs="+", type=Path, help="Image files or directories")
    parser.add_argument("--output", required=True, type=Path, help="Output PDF path")
    parser.add_argument("--manifest", type=Path, help="Explicit page order manifest")
    parser.add_argument("--overwrite", action="store_true", help="Allow replacing the output PDF")
    parser.add_argument("--contrast", type=float, default=1.04)
    parser.add_argument("--sharpness", type=float, default=1.35)
    ocr = parser.add_mutually_exclusive_group()
    ocr.add_argument("--ocr", action="store_true", help="Add a searchable OCR text layer")
    ocr.add_argument("--no-ocr", action="store_true", help="Create an image-only PDF")
    parser.add_argument("--languages", default="chi_sim+eng", help="OCR language set")
    return parser.parse_args()


def main() -> int:
    try:
        args = parse_args()
        inputs = collect_inputs(args.inputs)
        if args.manifest:
            inputs = load_manifest(args.manifest, inputs)
        if not args.ocr:
            build_image_pdf(
                inputs,
                args.output,
                args.overwrite,
                args.contrast,
                args.sharpness,
            )
            return 0

        validate_output_path(inputs, args.output, args.overwrite)
        _, ocrmypdf = check_ocr_dependencies(args.languages)
        with tempfile.TemporaryDirectory(prefix="image-pages-") as directory:
            image_pdf = Path(directory) / "image-pages.pdf"
            build_image_pdf(inputs, image_pdf, False, args.contrast, args.sharpness)
            _publish_ocr_result(
                image_pdf,
                args.output,
                args.languages,
                args.overwrite,
                ocrmypdf,
            )
        return 0
    except EXPECTED_CLI_ERRORS as error:
        message = " ".join(str(error).strip().splitlines()) or type(error).__name__
        print(f"error: {message}", file=sys.stderr)
        return CLI_ERROR_EXIT


if __name__ == "__main__":
    raise SystemExit(main())
