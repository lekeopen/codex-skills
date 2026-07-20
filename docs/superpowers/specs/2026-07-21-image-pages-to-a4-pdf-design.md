# Image Pages to A4 PDF Skill Design

## Goal

Create a reusable Codex skill named `image-pages-to-a4-pdf` that converts scanned page images into a correctly ordered, A4-sized, visually verified PDF, with optional OCR when local Tesseract dependencies are available.

## Scope

The skill accepts JPG, JPEG, and PNG page images. It determines page order from visible printed page numbers, uses content continuity and filenames only as secondary evidence, and asks for confirmation when ordering remains ambiguous.

It preserves source files and writes a new output PDF. Existing output files are not overwritten unless the user explicitly approves replacement.

## Processing Workflow

1. Discover and validate input image files.
2. Inspect visible page numbers and establish a page-order manifest.
3. Ask the user to resolve missing, duplicated, or conflicting page numbers when confidence is insufficient.
4. Correct EXIF orientation and convert each image to RGB.
5. Apply restrained contrast and sharpness enhancement.
6. Resize with Lanczos resampling onto a white 2480 x 3508 pixel A4 canvas at 300 DPI without cropping.
7. Build the ordered PDF.
8. When OCR is enabled, verify Tesseract and required language packs, then add a searchable text layer.
9. Verify page count, A4 dimensions, page rotation, and rendered visual output.

## OCR Behavior

OCR is optional. The script supports `--ocr` and `--no-ocr`; the skill selects OCR when the user requests searchable or copyable text.

The skill checks for Tesseract and the requested language packs before OCR. It does not install system packages. Missing dependencies produce actionable macOS and Ubuntu installation guidance. Image-only PDF generation remains available without OCR.

The default language set is Simplified Chinese plus English (`chi_sim+eng`).

## Components

- `SKILL.md`: triggering conditions, workflow, dependency handling, verification requirements, and common mistakes.
- `agents/openai.yaml`: display metadata and a default usage prompt.
- `scripts/build_a4_pdf.py`: deterministic image ordering manifest, A4 conversion, enhancement, PDF generation, and optional OCR orchestration.
- `tests/test_build_a4_pdf.py`: unit tests for ordering manifests, A4 sizing, source preservation, output collision handling, and dependency checks.

No README, changelog, bundled fonts, or unrelated documentation will be added.

## Command Interface

The script accepts explicit input paths or an input directory, an output path, an optional order manifest, enhancement controls with conservative defaults, and OCR flags. Explicit manifests take precedence over filename ordering.

The script exits nonzero with a concise diagnostic for invalid inputs, ambiguous or incomplete manifests, missing OCR dependencies, unsupported files, or output collisions.

## Verification

Automated tests cover deterministic behavior and error paths. End-to-end verification uses sample page images to confirm:

- output page count equals ordered input count;
- every page reports A4 dimensions;
- the source files remain unchanged;
- page order matches the manifest;
- rendered pages have no cropping, rotation, black blocks, or unreadable scaling.

The repository validation script and the skill-creator validator run before delivery.

## Compatibility and Risks

- Upscaling cannot recreate detail absent from the source; sharpening remains deliberately restrained.
- OCR quality depends on source quality and installed Tesseract language data.
- Pillow is required for image processing. OCR additionally requires Tesseract and a PDF text-layer tool available locally.
- The implementation favors portable subprocess calls and explicit dependency checks over automatic installation.
