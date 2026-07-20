# Codex Skills

[English](README.md) | [简体中文](README.zh-CN.md)

由 [lekeopen](https://github.com/lekeopen) 维护的可复用 Codex skills 集合。每个 skill 都位于仓库根目录下的独立目录中，可以按需单独安装。

## Skills 列表

| Skill | 用途 |
|---|---|
| [`brand-system-builder`](brand-system-builder/) | 建立、升级、集成、固化和治理品牌系统。 |
| [`social-distribution-setup`](social-distribution-setup/) | 搭建并排查基于 RSS、Make.com 和 Buffer 的多平台内容分发流程。 |
| [`wechat-webview-font-sizing`](wechat-webview-font-sizing/) | 诊断并修复微信内置浏览器中的字体缩放问题。 |
| [`image-pages-to-a4-pdf`](image-pages-to-a4-pdf/) | 按顺序整理扫描图片，生成经过验证的 A4 PDF，并可选择添加 OCR。 |

## 环境要求

运行仓库验证需要 Bash 和 Node.js。`image-pages-to-a4-pdf` 需要 Python 3 和 Pillow 来处理图片，运行验证还需要安装名称准确为 `pypdf` 的 Python 包。此外，它还需要 Poppler 提供的 `pdfinfo` 和 `pdftoppm`，用于检查 PDF 结构和渲染结果。

请在自己的运行环境中安装所需依赖，例如：

```bash
python3 -m pip install Pillow pypdf
# macOS
brew install poppler
# Ubuntu
sudo apt-get install poppler-utils
```

如果需要生成可搜索的 PDF，还需要自行安装 Tesseract、OCRmyPDF 和所需语言包，例如 `chi_sim` 和 `eng`。Skill 及其脚本不会自动安装这些依赖。

## 安装方法

先克隆仓库，然后只复制需要的 skill 到 Codex skills 目录。

克隆仓库并创建安装目录：

```bash
git clone https://github.com/lekeopen/codex-skills.git
cd codex-skills
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
```

安装品牌系统构建 skill：

```bash
cp -R brand-system-builder "${CODEX_HOME:-$HOME/.codex}/skills/brand-system-builder"
```

安装社交内容分发配置 skill：

```bash
cp -R social-distribution-setup "${CODEX_HOME:-$HOME/.codex}/skills/social-distribution-setup"
```

安装微信 WebView 字体适配 skill：

```bash
cp -R wechat-webview-font-sizing "${CODEX_HOME:-$HOME/.codex}/skills/wechat-webview-font-sizing"
```

安装图片页转 A4 PDF skill：

```bash
cp -R image-pages-to-a4-pdf "${CODEX_HOME:-$HOME/.codex}/skills/image-pages-to-a4-pdf"
```

安装完成后，请新建一个 Codex 任务，使 skill 列表重新加载。

## 验证

在仓库根目录运行：

```bash
bash scripts/validate-skills.sh
```

也可以运行以下命令检查仓库级约定：

```bash
bash tests/validate-repository.sh
```

## 添加新的 skill

以后新增的 skill 都放在仓库根目录下，与现有 skill 目录并列。目录名称必须与对应 `SKILL.md` 中的 `name` 一致，并将它添加到上面的 Skills 列表中。

如果 skill 包含脚本，需要在 `tests/skills/<name>.sh` 添加可执行的运行验证钩子。Skill 目录内只保留运行时需要的说明和资源；仓库级文档统一放在仓库根目录或 `docs/` 中。

## 参与贡献

贡献规范请参阅 [`CONTRIBUTING.md`](CONTRIBUTING.md)。本仓库采用 [MIT License](LICENSE) 开源许可。
