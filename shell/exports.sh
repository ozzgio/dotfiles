export EDITOR=nvim
export VISUAL=nvim

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# Lazy NVM — loads on first use, keeps shell startup instant
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  nvm()  { unset -f nvm node npm npx; source "$NVM_DIR/nvm.sh"; nvm "$@"; }
  node() { unset -f nvm node npm npx; source "$NVM_DIR/nvm.sh"; node "$@"; }
  npm()  { unset -f nvm node npm npx; source "$NVM_DIR/nvm.sh"; npm "$@"; }
  npx()  { unset -f nvm node npm npx; source "$NVM_DIR/nvm.sh"; npx "$@"; }
fi

alias hd="herdr"
alias hdr="herdr --remote"
alias cx="codex --yolo"
alias cdx="codex --yolo"
alias cc="claude --dangerously-skip-permissions"
alias cy="claude --dangerously-skip-permissions"

ccglm() {
  if command -v claude-glm >/dev/null 2>&1; then
    claude-glm --dangerously-skip-permissions "$@"
  elif command -v glm >/dev/null 2>&1; then
    glm --dangerously-skip-permissions "$@"
  else
    printf 'Neither claude-glm nor glm is available on PATH.\n' >&2
    return 127
  fi
}

hnuc() {
  herdr --remote nuc-local "$@" || herdr --remote nuc-tail "$@"
}

snuc() {
  ssh nuc-local "$@" || ssh nuc-tail "$@"
}
