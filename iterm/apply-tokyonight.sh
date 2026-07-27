#!/usr/bin/env bash
# Apply Tokyo Night (Storm) color scheme to iTerm2 Default profile.
# Run: bash apply-tokyonight.sh
# Revert: bash revert-colors.sh

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python3 "$DIR/_apply_colors.py" "$DIR/tokyonight-storm.itermcolors"
echo "Tokyo Night (Storm) applied. Restart iTerm2 (or Cmd+R) to see changes."
