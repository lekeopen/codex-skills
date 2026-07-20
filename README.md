# Codex Skills

Reusable Codex skills maintained by [lekeopen](https://github.com/lekeopen). Each skill is an independently installable top-level directory.

## Skills

| Skill | Purpose |
|---|---|
| [`brand-system-builder`](brand-system-builder/) | Establish, upgrade, integrate, freeze, and govern a brand system. |
| [`social-distribution-setup`](social-distribution-setup/) | Set up and troubleshoot RSS-driven social distribution with Make.com and Buffer. |
| [`wechat-webview-font-sizing`](wechat-webview-font-sizing/) | Diagnose and fix font scaling problems in the WeChat embedded browser. |

## Installation

Clone the repository, then copy only the skill you need into your Codex skills directory.

Prerequisites: Bash and Node.js.

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
