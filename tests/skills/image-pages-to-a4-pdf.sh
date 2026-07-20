#!/usr/bin/env bash

set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
temporary_root="$(mktemp -d)"

cleanup() {
  rm -rf -- "$temporary_root"
}

trap cleanup EXIT

python3 - "$temporary_root" <<'PY'
from pathlib import Path
import sys

from PIL import Image

root = Path(sys.argv[1])
images = root / "images"
images.mkdir()
Image.new("RGB", (100, 200), "red").save(images / "first.png")
Image.new("RGB", (100, 200), "blue").save(images / "second.png")
(root / "page-order.txt").write_text(
    "images/second.png\nimages/first.png\n", encoding="utf-8"
)
PY

python3 "$repository_root/image-pages-to-a4-pdf/scripts/build_a4_pdf.py" \
  "$temporary_root/images" \
  --manifest "$temporary_root/page-order.txt" \
  --output "$temporary_root/ordered-a4.pdf" \
  --no-ocr

python3 - "$temporary_root/ordered-a4.pdf" <<'PY'
from pypdf import PdfReader
import sys

expected_width = 595.2756
expected_height = 841.8898
reader = PdfReader(sys.argv[1])

def require(condition, message):
    if not condition:
        print(f"FAIL: {message}", file=sys.stderr)
        raise SystemExit(1)

require(len(reader.pages) == 2, f"expected two pages, got {len(reader.pages)}")
for index, page in enumerate(reader.pages, start=1):
    width = float(page.mediabox.width)
    height = float(page.mediabox.height)
    require(abs(width - expected_width) <= 0.1, f"page {index} has width {width}")
    require(abs(height - expected_height) <= 0.1, f"page {index} has height {height}")

def center_pixel(page):
    images = list(page.images)
    require(len(images) == 1, f"expected one raster image, got {len(images)}")
    image = images[0].image.convert("RGB")
    return image.getpixel((image.width // 2, image.height // 2))

first_page_pixel = center_pixel(reader.pages[0])
second_page_pixel = center_pixel(reader.pages[1])
require(
    first_page_pixel[2] > first_page_pixel[0],
    f"manifest order was not preserved on page 1: {first_page_pixel}",
)
require(
    second_page_pixel[0] > second_page_pixel[2],
    f"manifest order was not preserved on page 2: {second_page_pixel}",
)
PY

printf 'image-pages-to-a4-pdf runtime validation passed.\n'
