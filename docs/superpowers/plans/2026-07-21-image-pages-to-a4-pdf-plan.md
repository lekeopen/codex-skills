# Image Pages to A4 PDF Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and validate a reusable `image-pages-to-a4-pdf` skill that creates ordered 300 DPI A4 PDFs from page images and optionally adds searchable OCR using locally installed tools.

**Architecture:** Keep page-order judgment and visual QA in `SKILL.md`. Put deterministic image conversion, output safety, and OCR orchestration in one Python CLI, covered by unit tests and a repository runtime hook.

**Tech Stack:** Python 3, Pillow, `argparse`, `subprocess`, `unittest`, optional Tesseract and OCRmyPDF, existing Bash/Node validators.

## Global Constraints

- Create `image-pages-to-a4-pdf/` at the repository root.
- Accept JPG, JPEG, and PNG; use a white 2480 x 3508 pixel A4 canvas at 300 DPI without cropping.
- Preserve sources and refuse output collisions unless `--overwrite` is explicit.
- Use printed page numbers first; content continuity and filenames only as secondary evidence.
- Default OCR languages to `chi_sim+eng`; never install dependencies automatically.
- Do not commit, push, or merge unless the user explicitly asks.

---

### Task 1: Baseline and Package Scaffold

**Files:**
- Create: `image-pages-to-a4-pdf/SKILL.md`
- Create: `image-pages-to-a4-pdf/agents/openai.yaml`
- Create: `image-pages-to-a4-pdf/scripts/build_a4_pdf.py`
- Create: `image-pages-to-a4-pdf/tests/test_build_a4_pdf.py`
- Modify: `README.md`

**Interfaces:** Produces the generated skill package and records baseline omissions before the skill exists.

- [ ] Run a fresh-context baseline using: `Merge these unordered scanned JPG pages into a clear A4 PDF. Some pages have printed page numbers. Add OCR if available and do not damage the originals.` Record whether ordering confirmation, collision safety, A4 inspection, and rendering are omitted.
- [ ] Initialize with:

```bash
python3 "$CODEX_HOME/skills/.system/skill-creator/scripts/init_skill.py" image-pages-to-a4-pdf \
  --path . --resources scripts \
  --interface 'display_name=图片页合并为 A4 PDF' \
  --interface 'short_description=Order scanned pages and build searchable A4 PDFs' \
  --interface 'default_prompt=Use $image-pages-to-a4-pdf to order these page images and create a verified A4 PDF.'
```

Expected: `SKILL.md`, `agents/openai.yaml`, and `scripts/` exist.

- [ ] Add the README table row `| [image-pages-to-a4-pdf](image-pages-to-a4-pdf/) | Order scanned page images and create verified A4 PDFs with optional OCR. |` and the repository's standard `cp -R` installation command.

### Task 2: A4 Image Builder with TDD

**Files:**
- Create: `image-pages-to-a4-pdf/tests/test_build_a4_pdf.py`
- Replace: `image-pages-to-a4-pdf/scripts/build_a4_pdf.py`

**Interfaces:**
- `collect_inputs(paths: list[Path]) -> list[Path]`
- `load_manifest(path: Path, inputs: list[Path]) -> list[Path]`
- `prepare_page(path: Path, contrast: float, sharpness: float) -> Image.Image`
- `build_image_pdf(inputs: list[Path], output: Path, overwrite: bool, contrast: float, sharpness: float) -> None`
- CLI: `inputs`, `--output`, `--manifest`, `--overwrite`, `--contrast`, `--sharpness`, `--ocr`, `--no-ocr`, `--languages`.

- [ ] Write failing `unittest` cases using temporary generated images. Assert deterministic discovery, exact manifest order, rejection of missing/duplicate/foreign manifest entries, output size `(2480, 3508)`, unchanged source hashes, unsupported-file rejection, and `FileExistsError` on collisions.
- [ ] Run `python3 -m unittest image-pages-to-a4-pdf/tests/test_build_a4_pdf.py -v`. Expected: FAIL because builder functions are absent.
- [ ] Implement the minimal pipeline around this contract:

```python
A4_300_DPI = (2480, 3508)
SUPPORTED_SUFFIXES = {".jpg", ".jpeg", ".png"}

def prepare_page(path: Path, contrast: float = 1.04, sharpness: float = 1.35) -> Image.Image:
    with Image.open(path) as image:
        source = ImageOps.exif_transpose(image).convert("RGB")
        source = ImageEnhance.Contrast(source).enhance(contrast)
        resized = ImageOps.contain(source, A4_300_DPI, Image.Resampling.LANCZOS)
        resized = ImageEnhance.Sharpness(resized).enhance(sharpness)
    page = Image.new("RGB", A4_300_DPI, "white")
    page.paste(resized, ((page.width - resized.width) // 2, (page.height - resized.height) // 2))
    return page
```

`collect_inputs` sorts directory entries by case-folded name. `load_manifest` requires every discovered input exactly once. `build_image_pdf` checks collisions first, creates only the output parent, and saves at `resolution=300.0`.

- [ ] Re-run the focused test. Expected: all A4 builder tests PASS.

### Task 3: Optional OCR with TDD

**Files:**
- Modify: `image-pages-to-a4-pdf/tests/test_build_a4_pdf.py`
- Modify: `image-pages-to-a4-pdf/scripts/build_a4_pdf.py`

**Interfaces:**
- `check_ocr_dependencies(languages: str) -> tuple[str, str]`
- `add_ocr_layer(image_pdf: Path, output: Path, languages: str, overwrite: bool) -> None`

- [ ] Add failing tests that mock only executable lookup/subprocess. Require useful errors for missing Tesseract, OCRmyPDF, and language packs; verify `--no-ocr` performs no dependency check.
- [ ] Verify RED with `python3 -m unittest discover -s image-pages-to-a4-pdf/tests -v`.
- [ ] Implement `shutil.which` checks, parse `tesseract --list-langs`, and call OCRmyPDF with `--force-ocr --deskew --optimize 1 --language chi_sim+eng`. Build the image PDF in a temporary directory and move the completed OCR result only after success.
- [ ] Include diagnostics: `macOS: brew install tesseract tesseract-lang ocrmypdf` and `Ubuntu: sudo apt-get install tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-eng ocrmypdf`. Do not invoke installers.
- [ ] Re-run the suite. Expected: all tests PASS.

### Task 4: Skill Guidance and Forward Test

**Files:**
- Replace: `image-pages-to-a4-pdf/SKILL.md`
- Verify: `image-pages-to-a4-pdf/agents/openai.yaml`

**Interfaces:** Consumes `scripts/build_a4_pdf.py --help`; produces agent workflow requirements.

- [ ] Use this exact frontmatter:

```yaml
---
name: image-pages-to-a4-pdf
description: Use when scanned or photographed JPG, JPEG, or PNG document pages must be ordered by visible page numbers and combined into a clear A4 PDF, especially when 300 DPI output, optional searchable OCR, source preservation, or rendered page-order verification is required.
---
```

- [ ] Require the agent to inspect/confirm ordering, create an explicit manifest, preserve sources, use the bundled script, enable OCR only when searchable text is needed, avoid auto-installation, inspect `pdfinfo`, render every page, and disclose upscaling/OCR limitations.
- [ ] Repeat Task 1's baseline scenario with the skill. Expected: all safeguards and verifications are present. Tighten only observed gaps and repeat until it passes.

### Task 5: Repository Runtime Validation and Visual Acceptance

**Files:**
- Create: `tests/skills/image-pages-to-a4-pdf.sh`
- Verify: `README.md`

**Interfaces:** Produces an executable runtime hook used by `scripts/validate-skills.sh`.

- [ ] Write a Bash hook that creates a temp directory, generates two images with Pillow, runs the CLI with a reversed explicit manifest, and uses PyPDF to assert two A4 pages within 0.1 point. Use a cleanup trap and do not require OCR.
- [ ] Run:

```bash
python3 -m unittest discover -s image-pages-to-a4-pdf/tests -v
python3 "$CODEX_HOME/skills/.system/skill-creator/scripts/quick_validate.py" image-pages-to-a4-pdf
bash tests/skills/image-pages-to-a4-pdf.sh
bash scripts/validate-skills.sh
bash tests/validate-repository.sh
```

Expected: every command exits 0.

- [ ] Run the skill against the eight supplied pages. Inspect `pdfinfo`, render every page, and confirm order 1-8, A4 sizing, no cropping/rotation/black blocks, and legible text.
- [ ] Run `git status --short`, `git diff --check`, and `git diff -- README.md image-pages-to-a4-pdf tests/skills/image-pages-to-a4-pdf.sh`. Expected: only approved spec/plan, README, skill package, and hook changes; no commit.
