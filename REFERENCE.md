# Qoder CLI Reference

## Official Documentation
- [Qoder CLI Documentation](https://docs.qoder.com/zh/cli/using-cli)

## Key Features

### TUI Mode (Interactive)
- Default mode when running `qodercli` in project root
- Multiple input modes:
  - `>`: Conversation mode (default)
  - `!`: Bash mode for shell commands
  - `/`: Slash command mode
  - `#`: Memory editing mode
  - `\`: Multi-line input mode

### Print Mode (Non-interactive)
- Run with `qodercli --print`
- Output formats: text, json, stream-json
- Useful for automation and scripting

### Built-in Tools
- **Grep**: Search files and directories
- **Read**: Read file contents
- **Write**: Write to files
- **Bash**: Execute shell commands

### Slash Commands
| Command | Description |
|---------|-------------|
| `/login` | Login to Qoder account |
| `/help` | Show TUI help |
| `/init` | Initialize/update AGENTS.md memory file |
| `/memory` | Edit AGENTS.md memory file |
| `/quest` | Task delegation based on Spec |
| `/review` | Code review for local changes |
| `/resume` | View sessions and restore specific session |
| `/clear` | Clear current session history |
| `/compact` | Summarize current session history |
| `/usage` | Show account status and credits |
| `/status` | Show CLI status (version, model, account, etc.) |
| `/config` | Show system configuration |
| `/agents` | Manage sub-agents |
| `/bashes` | View running background bash tasks |
| `/release-notes` | Show update logs |
| `/vim` | Open external editor |
| `/feedback` | Submit feedback |
| `/quit` | Exit TUI |
| `/logout` | Logout from Qoder account |

### Advanced Options
- `-w`: Specify workspace directory
- `-c`: Continue last session
- `-r`: Restore specific session
- `--allowed-tools`: Allow specific tools only
- `--disallowed-tools`: Disallow specific tools
- `--max-turns`: Maximum conversation turns
- `--yolo`: Skip permission checks

### MCP Services
- Integrate with standard MCP tools
- Example: `qodercli mcp add playwright -- npx -y @playwright/mcp@latest`
- Management commands:
  - `qodercli mcp list`
  - `qodercli mcp remove <service>`

### Worktree Tasks
- Parallel task execution using Git worktrees
- Commands:
  - `qodercli --worktree "job description"`
  - `qodercli jobs --worktree`
  - `qodercli rm <jobId>`

### Memory System
- Uses `AGENTS.md` as memory file
- Locations:
  - User-level: `~/.qoder/AGENTS.md`
  - Project-level: `${project}/AGENTS.md`

### Subagents
- Specialized AI agents for specific tasks
- Create in `~/.qoder/agents/` or `${project}/agents/`
- Frontmatter required with name, description, and tools

### Commands
- Extend slash commands with custom prompts
- Store in `~/.qoder/commands/` or `${project}/commands/`

### Hooks
- Integration points for external systems
- Configurable in settings.json
- Currently supports notification hooks