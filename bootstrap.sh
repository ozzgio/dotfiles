#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles"
OS="$(uname -s)"

# Self-clone if not already present
if [ ! -d "$DOTFILES" ]; then
  git clone https://github.com/ozzgio/dotfiles.git "$DOTFILES"
fi

echo "→ Installing dependencies..."

setup_mac() {
  command -v brew &>/dev/null || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install neovim ripgrep fd lazygit
}

setup_linux() {
  sudo apt-get update -qq
  sudo apt-get install -y ripgrep fd-find curl git
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod +x nvim-linux-x86_64.appimage
  sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
}

case "$OS" in
  Darwin) command -v nvim &>/dev/null || setup_mac ;;
  Linux)  command -v nvim &>/dev/null || setup_linux ;;
esac

echo "→ Symlinking configs..."

# nvim
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"

# claude
mkdir -p "$HOME/.claude"
ln -sfn "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"

# codex
mkdir -p "$HOME/.codex"
ln -sfn "$DOTFILES/codex/config.toml" "$HOME/.codex/config.toml"

# shell exports — append source line if not already present
add_source() {
  local file="$1"
  local line="source \"$DOTFILES/shell/exports.sh\""
  if [ -f "$file" ] && ! grep -q "dotfiles/shell/exports.sh" "$file"; then
    echo "" >> "$file"
    echo "# dotfiles" >> "$file"
    echo "$line" >> "$file"
  fi
}

case "$OS" in
  Darwin) add_source "$HOME/.zshrc" ;;
  Linux)  add_source "$HOME/.bashrc" ;;
esac

echo "✓ Done. Run: nvim"
