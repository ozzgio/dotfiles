export EDITOR=nvim
export VISUAL=nvim

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

AI_SECRETS_FILE="$HOME/.config/ai-secrets.env"
if [ -f "$AI_SECRETS_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$AI_SECRETS_FILE"
  set +a
fi
unset AI_SECRETS_FILE

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

claude-glm() {
  local token="${ZAI_ANTHROPIC_AUTH_TOKEN:-${ANTHROPIC_AUTH_TOKEN:-}}"
  if [ -z "$token" ]; then
    printf 'Missing ZAI_ANTHROPIC_AUTH_TOKEN in ~/.config/ai-secrets.env\n' >&2
    return 1
  fi

  ANTHROPIC_BASE_URL="${ZAI_ANTHROPIC_BASE_URL:-https://api.z.ai/api/anthropic}" \
    ANTHROPIC_AUTH_TOKEN="$token" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="${ZAI_OPUS_MODEL:-glm-5.2[1m]}" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="${ZAI_SONNET_MODEL:-glm-5.2[1m]}" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="${ZAI_HAIKU_MODEL:-glm-4.7}" \
    CLAUDE_CODE_AUTO_COMPACT_WINDOW="${CLAUDE_CODE_AUTO_COMPACT_WINDOW:-1000000}" \
    claude --dangerously-skip-permissions "$@"
}

ccglm() {
  if type claude-glm >/dev/null 2>&1; then
    claude-glm "$@"
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
