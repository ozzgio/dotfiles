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
| Herdr | `~/.config/herdr/config.toml` |
| tmux | `~/.tmux.conf` |
| Claude | `~/.claude/settings.json` |
| Codex | host-local `~/.codex/config.toml` from `codex/config.<OS>.toml` |
| Shell exports (EDITOR, VISUAL) | sourced into `.zshrc` / `.bashrc` |

## Shell shortcuts

| Command | Action |
|---------|--------|
| `hnuc` | Open Herdr on the NUC, trying LAN first and Tailscale second |
| `snuc` | SSH to the NUC, trying LAN first and Tailscale second |
| `hd` | Run `herdr` |
| `hdr` | Run `herdr --remote` |
| `cc` / `cy` | Run Claude Code with permission prompts skipped |
| `cx` / `cdx` | Run Codex with `--yolo` |
| `ccglm` | Run Claude Code through the local `claude-glm` Z.ai/GLM settings |

Private AI provider secrets are loaded from:

```bash
~/.config/ai-secrets.env
```

Use [shell/ai-secrets.example.env](shell/ai-secrets.example.env) as the template. Keep the real file outside git.

## Terminal-first AI workflow

Use Herdr when running multiple agents, especially Codex, Claude Code, and GLM:

```bash
herdr
```

Inside Herdr:

| Key | Action |
|-----|--------|
| `<prefix> alt-z` | Open LazyVim Zdiff for uncommitted changes in the focused repo |
| `<prefix> alt-d` | Open LazyVim Zdiff against `main` |
| `<prefix> alt-n` | Open LazyVim in the focused repo |
| `<prefix> alt-g` | Open lazygit in the focused repo |
| `<prefix> alt-c` | Start Codex in a pane |
| `<prefix> alt-a` | Start Claude Code in a pane |
| `<prefix> alt-m` | Start GLM in a pane |

On macOS, set iTerm2 Option handling so Herdr receives these shortcuts:

```text
iTerm2 -> Settings -> Profiles -> Keys -> Left Option key -> Esc+
```

Do the same for Right Option if you use it.

In LazyVim:

| Key | Action |
|-----|--------|
| `<leader> zd` | Review uncommitted changes with Zdiff |
| `<leader> zD` | Review changes against `main` with Zdiff |
| `<leader> cp` | Copy current file or visual line range plus a prompt for an agent pane |

For remote work on the NUC, either SSH first and run `herdr`, or use the local thin client:

```bash
hnuc
```

Use tmux when you want a lighter terminal/session workflow without agent status tracking:

```bash
tmux
```

Inside tmux:

| Key | Action |
|-----|--------|
| `<prefix> f` | Pick or create a tmux session for a repo |
| `<prefix> w` | Pick or create a git worktree for the current repo |
| `<prefix> r` | Reload tmux config |
`tmux-sessionizer` searches these roots by default: `~/code`, `~/Documents/code`, `~/projects`, `~/.dotfiles`, and `/Volumes/P3 1/repo`. Override them with a colon-separated `TMS_DIRS` value in your shell config.
