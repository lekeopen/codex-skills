---
name: image-pages-to-a4-pdf
description: Use when scanned or photographed JPG, JPEG, or PNG document pages must be ordered by visible page numbers and combined into a clear A4 PDF, especially when 300 DPI output, optional searchable OCR, source preservation, or rendered page-order verification is required.
---

# Image Pages to A4 PDF

Create a new, ordered 300 DPI A4 PDF without modifying its source images. Page order is a visual judgment; the bundled script performs deterministic conversion once the order is explicit.

## Dependency Check

Before processing, verify the required local runtime:

```bash
python3 --version
python3 -c 'from PIL import Image'
python3 -c 'from pypdf import PdfReader'
command -v pdfinfo
command -v pdftoppm
```

If a required dependency is missing, tell the user what is missing and ask them to install it. Do not run installers automatically. Actionable examples are `python3 -m pip install Pillow pypdf`, `brew install poppler` on macOS, and `sudo apt-get install poppler-utils` on Ubuntu.

For OCR, additionally run `command -v tesseract`, `command -v ocrmypdf`, and `tesseract --list-langs`; the script reports macOS and Ubuntu commands for missing OCR tools or language packs.

## Required Workflow

1. Discover the JPG, JPEG, or PNG inputs and inspect every page. Order them by visible printed page numbers; use content continuity and filenames only as secondary evidence. If numbers are missing, duplicated, conflicting, or uncertain, ask the user to confirm the order before building.
2. Write an explicit newline-delimited manifest beside the sources. It must list each discovered image exactly once, in the confirmed order, using paths relative to the manifest. Keep the manifest as the order record.
3. Preserve all sources. Choose a new output path and do not replace an existing PDF unless the user explicitly approves replacement; only then use `--overwrite`.
4. Run the bundled script with the manifest. For example:

   ```bash
   SKILL_DIRECTORY="/absolute/path/to/image-pages-to-a4-pdf"
   OUTPUT_PDF="/absolute/path/to/output/ordered-a4.pdf"
   python3 "$SKILL_DIRECTORY/scripts/build_a4_pdf.py" /absolute/path/to/scans \
     --manifest /absolute/path/to/scans/page-order.txt \
     --output "$OUTPUT_PDF" --no-ocr
   ```

   Request `--ocr --languages chi_sim+eng` only when the user needs searchable or copyable text. Before OCR, check that local Tesseract, OCRmyPDF, and the requested language packs are available. Do not install packages automatically; give the script's actionable diagnostics if dependencies are missing.
5. Verify the result before delivery:
   - Get the page count, then inspect the structural fields for every page, not only the default summary:

     ```bash
     PAGE_COUNT="$(pdfinfo "$OUTPUT_PDF" | awk '/^Pages:/ {print $2}')"
     pdfinfo -f 1 -l "$PAGE_COUNT" "$OUTPUT_PDF"
     ```

     Confirm there is a page-specific size and rotation entry for each page, every size is A4 (about 595.28 x 841.89 points), and every rotation is expected.
   - Render every PDF page: run `mkdir -p rendered`, then for example `pdftoppm -png -r 150 "$OUTPUT_PDF" rendered/page`; inspect every rendered page for manifest order, cropping, rotation, black blocks, and legibility.
   - Confirm the source files are unchanged and report the manifest and verification results.

## Delivery Notes

State whether the PDF is image-only or searchable, and name the OCR languages when used. Explain that upscaling to 300 DPI cannot restore detail absent from the scans, and that OCR accuracy depends on scan quality and installed language data.

The current Pillow multipage PDF writer holds every prepared full-resolution page in memory (roughly 26 MB per RGB A4 page before overhead). For a large scan set, check available memory first and split the input into smaller batches if the estimated working set is unsafe. Split the confirmed manifest into ordered manifest chunks and pass only that chunk's image paths as inputs (not the whole source directory), because each manifest must enumerate every input passed to that run. Build distinct batch PDFs without overwrite, then merge them in batch order with locally installed `pypdf` into another new file:

```bash
MERGED_OUTPUT="/absolute/path/to/merged-a4.pdf"
python3 - "$MERGED_OUTPUT" /absolute/path/to/batch-001.pdf /absolute/path/to/batch-002.pdf <<'PY'
from pathlib import Path
import sys
from pypdf import PdfWriter

output = Path(sys.argv[1])
writer = PdfWriter()
for batch_pdf in sys.argv[2:]:
    writer.append(batch_pdf)
with output.open("xb") as destination:
    writer.write(destination)
PY
```

The exclusive `xb` mode refuses an existing merge output. After merging, repeat the all-page structural and rendered verification on the merged PDF.

## Common Mistakes

- Do not trust filename sorting over visible numbering.
- Do not omit the manifest because the order looks obvious.
- Do not enable OCR merely because the tool exists; use it for a searchable-text need.
- Do not treat successful PDF creation as visual verification; inspect every rendered page.
