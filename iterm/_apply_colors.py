#!/usr/bin/env python3
"""Patch the iTerm2 Default profile colors and appearance."""
import plistlib, sys, os, subprocess

COLOR_KEYS = [
    "Ansi 0 Color", "Ansi 1 Color", "Ansi 2 Color", "Ansi 3 Color",
    "Ansi 4 Color", "Ansi 5 Color", "Ansi 6 Color", "Ansi 7 Color",
    "Ansi 8 Color", "Ansi 9 Color", "Ansi 10 Color", "Ansi 11 Color",
    "Ansi 12 Color", "Ansi 13 Color", "Ansi 14 Color", "Ansi 15 Color",
    "Background Color", "Bold Color", "Cursor Color", "Cursor Text Color",
    "Foreground Color", "Link Color", "Selected Text Color", "Selection Color",
]

PREFS = os.path.expanduser("~/Library/Preferences/com.googlecode.iterm2.plist")

src = sys.argv[1]
with open(src, "rb") as f:
    colors = plistlib.load(f)

with open(PREFS, "rb") as f:
    prefs = plistlib.load(f)

profiles = prefs.get("New Bookmarks", [])
patched = False
for p in profiles:
    if p.get("Name") == "Default":
        for k in COLOR_KEYS:
            if k in colors:
                p[k] = colors[k]
        p["Color Preset Name"] = ""
        p["Transparency"] = 0.06
        p["Blur"] = True
        p["Blur Radius"] = 8.0
        p["Use Bright Bold"] = True
        p["Cursor Type"] = 2
        p["Blinking Cursor"] = True
        p["Cursor Boost"] = 0.12
        p["Minimum Contrast"] = 0.08
        p["Vertical Spacing"] = 1.05
        p["Horizontal Spacing"] = 1.0
        p["Silence Bell"] = True
        p["Visual Bell"] = False
        patched = True
        break

if not patched:
    print("ERROR: Default profile not found in iTerm2 preferences.", file=sys.stderr)
    sys.exit(1)

with open(PREFS, "wb") as f:
    plistlib.dump(prefs, f, fmt=plistlib.FMT_BINARY)

# Tell iTerm2 to reload its preferences
subprocess.run(
    ["defaults", "read", "com.googlecode.iterm2"],
    capture_output=True,
)
print(f"Applied {len(colors)} color keys from {os.path.basename(src)}")
