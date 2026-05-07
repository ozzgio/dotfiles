# dotfiles

Personal dotfiles for Mac and NUC. Installs nvim (LazyVim), sets default editor, and symlinks Claude and Codex configs.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ozzgio/dotfiles/main/bootstrap.sh | bash
```

## What it sets up

| Config | Location |
|--------|----------|
| Neovim (LazyVim) | `~/.config/nvim` |
| Claude | `~/.claude/settings.json` |
| Codex | `~/.codex/config.toml` |
| Shell exports (EDITOR, VISUAL) | sourced into `.zshrc` / `.bashrc` |
