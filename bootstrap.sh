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
  brew tap heroku/brew >/dev/null
  brew trust --formula heroku/brew/heroku >/dev/null || true
  brew bundle --file="$DOTFILES/Brewfile"
}

setup_linux() {
  sudo apt-get update -qq
  sudo apt-get install -y ripgrep fd-find fzf curl git tmux

  # neovim — latest via AppImage
  if ! command -v nvim &>/dev/null; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod +x nvim-linux-x86_64.appimage
    sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
  fi

  # gh — GitHub CLI
  if ! command -v gh &>/dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq && sudo apt-get install -y gh
  fi

  # lazygit — latest binary
  if ! command -v lazygit &>/dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
      | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz \
      "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit -D -t /usr/local/bin/
    rm /tmp/lazygit.tar.gz /tmp/lazygit
  fi

  # herdr — terminal-native agent multiplexer
  if ! command -v herdr &>/dev/null; then
    curl -fsSL https://herdr.dev/install.sh | sh
  fi
}

case "$OS" in
  Darwin) setup_mac ;;
  Linux)  setup_linux ;;
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
ln -sfn "$DOTFILES/codex/hooks.json" "$HOME/.codex/hooks.json"

# herdr
mkdir -p "$HOME/.config/herdr"
ln -sfn "$DOTFILES/herdr/config.toml" "$HOME/.config/herdr/config.toml"

# tmux
ln -sfn "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# local scripts
mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES"/bin/*; do
  [ -f "$script" ] || continue
  ln -sfn "$script" "$HOME/.local/bin/$(basename "$script")"
done

"$DOTFILES/bin/herdr-install-integrations"

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
  Darwin)
    add_source "$HOME/.zshrc"
    add_source "$HOME/.bashrc"
    if [ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]; then
      bash "$DOTFILES/iterm/apply-catppuccin.sh" || true
    fi
    ;;
  Linux)
    add_source "$HOME/.bashrc"
    add_source "$HOME/.zshrc"
    ;;
esac

echo "✓ Done. Run: nvim"
