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

hnuc() {
  herdr --remote nuc-local "$@" || herdr --remote nuc-tail "$@"
}

snuc() {
  ssh nuc-local "$@" || ssh nuc-tail "$@"
}
