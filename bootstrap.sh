#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles"
OS="$(uname -s)"

echo "→ Checking dependencies..."

install_nvim_mac() {
  command -v brew &>/dev/null ||
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install neovim ripgrep fd lazygit
}

install_nvim_linux() {
  sudo apt-get install -y ripgrep fd-find lazygit curl
  # Latest nvim via AppImage
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod +x nvim-linux-x86_64.appimage
  sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
}

case "$OS" in
Darwin) command -v nvim &>/dev/null || install_nvim_mac ;;
Linux) command -v nvim &>/dev/null || install_nvim_linux ;;
esac

echo "→ Symlinking configs..."
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "✓ Done. Run: nvim"
