# Claude Code Custom Statusline

A minimal shell script statusline for Claude Code that displays model info, context usage, cost, rate limits, and git context.

## Preview

```
🤖 Claude Sonnet 4.6 | 🧠 12% | 💰 $0.04 | ⏱️ 5h ████░░░░░░ 42% resets 2:00PM
📁 my-app | 🌿 feature/payments +3 ~2
```

| Element | Description |
|---------|-------------|
| 🤖 Model | Active Claude model name |
| 🧠 Context | Context window usage percentage |
| 💰 Cost | Session cost in USD |
| ⏱️ Rate limit | 5-hour usage bar with reset time (color-coded) |
| 📁 Folder | Project root directory name |
| 🌿 Branch | Current branch with staged (+) and modified (~) file counts |

The rate limit bar changes color based on usage:
- Green — below 70%
- Yellow — 70-89%
- Red — 90%+

## Requirements

- [Claude Code](https://claude.ai/code) CLI (v1.2.80+ for rate limit data)
- `jq` — JSON parsing (`brew install jq`)
- `git`

## Installation

### Automatic

```sh
./install.sh
```

### Manual

1. Copy the script and make it executable:

```sh
cp statusline-command.sh ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

2. Add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "sh ~/.claude/statusline-command.sh",
    "padding": 0
  }
}
```

3. Restart Claude Code.

## JSON Input

Claude Code pipes this JSON to the statusline command on each update:

```json
{
  "cwd": "/Users/you/projects/my-app",
  "model": { "display_name": "Claude Sonnet 4.6" },
  "context_window": { "used_percentage": 12 },
  "cost": { "total_cost_usd": 0.04 },
  "workspace": { "current_dir": "/Users/you/projects/my-app" },
  "rate_limits": {
    "five_hour": { "used_percentage": 42, "resets_at": 1742651200 },
    "seven_day": { "used_percentage": 18, "resets_at": 1743120000 }
  }
}
```

## Customization

Edit `~/.claude/statusline-command.sh` directly. Common tweaks:

- **Enable 7-day rate limit bar** — uncomment the `rl_7d` line near the bottom
- **Change icons** — replace any emoji in the `printf` line at the end
- **Add/remove fields** — modify the final `printf` format string

## Credits

Based on the blog post [Claude Code Custom Statusline](https://www.dandoescode.com/blog/claude-code-custom-statusline) by Dan Does Code.
