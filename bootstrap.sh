#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles"
OS="$(uname -s)"

# Self-clone if not already present
if [ ! -d "$DOTFILES" ]; then
  git clone https://github.com/ozzgio/dotfiles.git "$DOTFILES"
  exec "$DOTFILES/bootstrap.sh"
fi

echo "→ Installing dependencies..."

setup_mac() {
  command -v brew &>/dev/null ||
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
Linux) command -v nvim &>/dev/null || setup_linux ;;
esac

echo "→ Symlinking configs..."
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "✓ Done. Run: nvim"
