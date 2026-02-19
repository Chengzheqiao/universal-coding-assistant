# Qoder CLI Skill

Qoder CLI 是一个强大的 AI 编程助手，支持 TUI 交互模式、Print 非交互模式、Worktree 并行任务、Subagent 专门代理等多种功能。

## 功能特性

- **TUI 模式**: 交互式命令行界面，支持对话、Bash、斜杠命令等多种输入模式
- **Print 模式**: 非交互式模式，适合自动化脚本集成
- **Worktree 任务**: 并行执行多个任务，避免文件冲突
- **Subagent 管理**: 创建和管理专门的 AI 代理处理特定任务
- **MCP 服务**: 集成标准 MCP 工具（如 Playwright、Context7 等）
- **权限控制**: 细粒度的工具执行权限管理
- **记忆文件**: 使用 AGENTS.md 作为上下文记忆
- **命令扩展**: 自定义斜杠命令扩展功能
- **Hooks 集成**: 任务执行关键阶段的外部集成

## 使用场景

- 代码审查和质量检查
- 系统设计和架构分析
- 自动化开发任务
- 多任务并行处理
- 安全性检查和漏洞扫描
- 项目文档生成和维护

## 快速开始

```bash
# 进入 TUI 交互模式
qodercli

# 非交互式运行
qodercli --print -q "分析这段代码"

# 创建 Worktree 任务
qodercli --worktree "重构用户认证模块"
```

## 文档

- [官方文档](https://docs.qoder.com/zh/cli/using-cli)
- [技能配置](REFERENCE.md)
- [脚本使用](scripts/)