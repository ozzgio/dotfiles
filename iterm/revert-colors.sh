#!/usr/bin/env bash
# Revert iTerm2 Default profile to backed-up colors.

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python3 "$DIR/_apply_colors.py" "$DIR/backup-current.itermcolors"
echo "Colors reverted. Restart iTerm2 (or Cmd+R) to see changes."
