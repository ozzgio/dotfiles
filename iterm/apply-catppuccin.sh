#!/usr/bin/env bash
# Apply Catppuccin Mocha color scheme to iTerm2 Default profile.
# Run: bash apply-catppuccin.sh
# Revert: bash revert-colors.sh

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python3 "$DIR/_apply_colors.py" "$DIR/catppuccin-mocha.itermcolors"
echo "Catppuccin Mocha applied. Restart iTerm2 (or Cmd+R) to see changes."
