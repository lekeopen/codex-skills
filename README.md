# Codex Skills

[English](README.md) | [简体中文](README.zh-CN.md)

Reusable Codex skills maintained by [lekeopen](https://github.com/lekeopen). Each skill is an independently installable top-level directory.

## Skills

| Skill | Purpose |
|---|---|
| [`brand-system-builder`](brand-system-builder/) | Establish, upgrade, integrate, freeze, and govern a brand system. |
| [`social-distribution-setup`](social-distribution-setup/) | Set up and troubleshoot RSS-driven social distribution with Make.com and Buffer. |
| [`wechat-webview-font-sizing`](wechat-webview-font-sizing/) | Diagnose and fix font scaling problems in the WeChat embedded browser. |
| [`image-pages-to-a4-pdf`](image-pages-to-a4-pdf/) | Order scanned page images and create verified A4 PDFs with optional OCR. |
| [`evaluating-open-source-tools`](evaluating-open-source-tools/) | Test open-source tools in stages and make evidence-backed adoption decisions. |

## Prerequisites

Repository validation requires Bash and Node.js. `image-pages-to-a4-pdf`
requires Python 3 and Pillow for conversion, plus the exact `pypdf` package for
runtime validation. It also requires Poppler's `pdfinfo` and `pdftoppm` for
structural and rendered-page verification.

Install required dependencies in your own environment, for example:

```bash
python3 -m pip install Pillow pypdf
# macOS
brew install poppler
# Ubuntu
sudo apt-get install poppler-utils
```

Searchable output additionally requires user-installed Tesseract, OCRmyPDF,
and the requested language packs (for example, `chi_sim` and `eng`). The skill
and its scripts never install dependencies automatically.

## Installation

Clone the repository, then copy only the skill you need into your Codex skills directory.

Clone once:

```bash
git clone https://github.com/lekeopen/codex-skills.git
cd codex-skills
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
```

Install Brand System Builder:

```bash
cp -R brand-system-builder "${CODEX_HOME:-$HOME/.codex}/skills/brand-system-builder"
```

Install Social Distribution Setup:

```bash
cp -R social-distribution-setup "${CODEX_HOME:-$HOME/.codex}/skills/social-distribution-setup"
```

Install WeChat WebView Font Sizing:

```bash
cp -R wechat-webview-font-sizing "${CODEX_HOME:-$HOME/.codex}/skills/wechat-webview-font-sizing"
```

Install Image Pages to A4 PDF:

```bash
cp -R image-pages-to-a4-pdf "${CODEX_HOME:-$HOME/.codex}/skills/image-pages-to-a4-pdf"
```

Install Evaluating Open Source Tools:

```bash
cp -R evaluating-open-source-tools "${CODEX_HOME:-$HOME/.codex}/skills/evaluating-open-source-tools"
```

Start a new Codex task after installation so the skill catalog refreshes.

## Validation

From the repository root, run:

```bash
bash scripts/validate-skills.sh
```

The repository-level contract can also be checked with `bash tests/validate-repository.sh`.

## Adding skills

Add each future skill as a top-level sibling directory whose name matches the `name` in its `SKILL.md`. Add it to the Skills index above. If the skill contains scripts, add an executable runtime validation hook at `tests/skills/<name>.sh`. Keep only runtime instructions and resources inside the skill package; place repository-wide documentation at the repository root.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). This repository is licensed under the [MIT License](LICENSE).
