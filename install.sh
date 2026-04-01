#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
STATUSLINE_SCRIPT="$CLAUDE_DIR/statusline-command.sh"

echo "Installing Claude Code statusline..."

# Check dependencies
if ! command -v jq > /dev/null 2>&1; then
  echo "Error: jq is required but not installed."
  echo "Install it with: brew install jq"
  exit 1
fi

if ! command -v git > /dev/null 2>&1; then
  echo "Error: git is required but not installed."
  exit 1
fi

# Ensure ~/.claude directory exists
mkdir -p "$CLAUDE_DIR"

# Copy statusline script
cp "$SCRIPT_DIR/statusline-command.sh" "$STATUSLINE_SCRIPT"
chmod +x "$STATUSLINE_SCRIPT"
echo "Installed statusline script to $STATUSLINE_SCRIPT"

# Update settings.json
if [ -f "$SETTINGS_FILE" ]; then
  # Merge statusLine config into existing settings
  tmp=$(mktemp)
  jq '. + {
    "statusLine": {
      "type": "command",
      "command": "sh ~/.claude/statusline-command.sh",
      "padding": 0
    }
  }' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
  echo "Updated $SETTINGS_FILE"
else
  # Create new settings.json
  cat > "$SETTINGS_FILE" << 'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "sh ~/.claude/statusline-command.sh",
    "padding": 0
  }
}
EOF
  echo "Created $SETTINGS_FILE"
fi

echo ""
echo "Installation complete!"
echo "Restart Claude Code to see the statusline."
echo ""
echo "Preview:"
echo "  🤖 Claude Sonnet 4.6 | 🧠 12% | 💰 \$0.04 | ⏱️ 5h ████░░░░░░ 42% resets 2:00PM"
echo "  📁 my-app | 🌳 my-app-payments | 🌿 feature/payments"
