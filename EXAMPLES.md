# Qoder CLI Skill 使用示例

## 1. 基本 TUI 模式
```bash
# 在项目根目录启动交互式模式
qoder tui

# 指定工作区目录
qoder tui --workspace /path/to/project
```

## 2. Print 模式（非交互式）
```bash
# 执行单次查询并输出 JSON
qoder print --query "分析这个项目的架构" --output-format json

# 限制工具使用
qoder print --query "读取 README.md" --allowed-tools READ --output-format text
```

## 3. Worktree 任务管理
```bash
# 创建并行开发任务
qoder worktree create --description "实现用户认证功能" --branch feature/auth

# 查看所有任务
qoder worktree list

# 删除任务
qoder worktree remove <task-id>
```

## 4. Subagent 管理
```bash
# 创建代码审查子代理
qoder subagent create --name code-review --description "代码质量检查专家" --tools Read,Grep,Bash

# 列出所有子代理
qoder subagent list

# 使用子代理
qoder tui --subagent code-review
```

## 5. MCP 服务集成
```bash
# 添加浏览器控制 MCP
qoder mcp add --name playwright --command "npx -y @playwright/mcp@latest"

# 列出 MCP 服务
qoder mcp list

# 移除 MCP 服务
qoder mcp remove --name playwright
```

## 6. 权限配置
```bash
# 允许特定目录的读写
qoder permission allow --pattern "Read(/project/src/**)" --pattern "Edit(/project/src/**)"

# 拒绝网络访问
qoder permission deny --pattern "WebFetch(domain:malicious.com)"

# 配置 Bash 命令权限
qoder permission ask --pattern "Bash(npm run test:*)"
```

## 7. 记忆文件管理
```bash
# 初始化项目记忆文件
qoder memory init

# 编辑记忆文件
qoder memory edit

# 查看记忆文件内容
qoder memory show
```

## 8. 命令管理
```bash
# 创建自定义命令
qoder command create --name quest --description "智能工作流编排器"

# 列出命令
qoder command list

# 执行命令
qoder command run --name quest
```

## 9. Hooks 配置
```bash
# 配置通知 Hook
qoder hooks configure --type notification --script "~/notification.sh"

# 查看 Hooks 配置
qoder hooks show
```