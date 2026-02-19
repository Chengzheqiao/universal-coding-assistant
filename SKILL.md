# Universal Coding Assistant (Qoder CLI)

This skill integrates **Qoder CLI** as your primary AI-powered programming assistant, providing a unified interface for coding, debugging, testing, and project management.

## Core Capabilities

- **Interactive Development**: Full TUI (Text User Interface) mode with conversation, command execution, and memory editing
- **Automated Workflows**: Non-interactive Print mode for CI/CD and scripted operations
- **Parallel Task Execution**: Worktree-based isolation for concurrent development tasks
- **Specialized Agents**: Subagents for specific domains (testing, review, documentation, etc.)
- **Tool Integration**: MCP (Model Context Protocol) support for external development tools
- **Context Awareness**: Project-specific memory via `AGENTS.md` files
- **Security Controls**: Fine-grained permission system for safe execution

## When to Use This Skill

Use this skill whenever you need to:
- Write, debug, or refactor code
- Run automated tests or generate reports  
- Manage complex development workflows
- Perform code reviews or security audits
- Set up development environments
- Execute shell commands in context-aware manner
- Integrate external tools into your workflow

## Primary Usage Patterns

### Quick Tasks (Print Mode)
```bash
qodercli -p "Fix the failing unit tests in auth module"
```

### Interactive Development (TUI Mode)
```bash
qodercli  # Starts interactive session with full capabilities
```

### Parallel Feature Development
```bash
qodercli --worktree "Implement payment processing API"
```

### Code Review & Quality Assurance
```bash
# In TUI mode
/review
```

## Configuration Hierarchy

Settings are loaded in priority order:
1. `${project}/.qoder/settings.local.json` (local overrides)
2. `${project}/.qoder/settings.json` (project settings)  
3. `~/.qoder/settings.json` (user defaults)

## Security & Permissions

Always configure appropriate permissions before running untrusted code:
- Use `allow` strategy for trusted projects
- Use `deny` strategy for sensitive environments
- Use `ask` strategy for interactive confirmation

## Integration with OpenClaw

This skill serves as your default programming assistant within OpenClaw, enabling seamless code generation, execution, and management across all development contexts.