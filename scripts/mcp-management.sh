#!/bin/bash
# Qoder CLI MCP 服务管理脚本

set -e

# 配置变量
QODER_CLI="qodercli"
DEFAULT_MCP_DIR="$HOME/.qoder"

# 显示帮助信息
show_help() {
    echo "Qoder CLI MCP 服务管理"
    echo ""
    echo "用法: $0 [选项] [命令]"
    echo ""
    echo "命令:"
    echo "  list                    列出所有 MCP 服务"
    echo "  add <name> <command>    添加 MCP 服务"
    echo "  remove <name>           移除 MCP 服务"
    echo "  show-config             显示 MCP 配置文件位置"
    echo ""
    echo "选项:"
    echo "  -w, --workspace DIR     指定工作区目录"
    echo "  -t, --type TYPE         设置 MCP 服务类型 (stdio|sse|streamable-http)"
    echo "  -s, --scope SCOPE       设置范围 (user|project)"
    echo "  -h, --help              显示此帮助信息"
}

# 解析命令行参数
parse_args() {
    local workspace=""
    local mcp_type=""
    local scope=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -w|--workspace)
                workspace="$2"
                shift 2
                ;;
            -t|--type)
                mcp_type="$2"
                shift 2
                ;;
            -s|--scope)
                scope="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                break
                ;;
        esac
    done
    
    # 设置环境变量
    if [[ -n "$workspace" ]]; then
        export QODER_WORKSPACE="$workspace"
    fi
    
    # 构建命令选项
    local cmd_options=""
    if [[ -n "$mcp_type" ]]; then
        cmd_options="$cmd_options -t $mcp_type"
    fi
    if [[ -n "$scope" ]]; then
        cmd_options="$cmd_options -s $scope"
    fi
    
    echo "$cmd_options"
}

# 主函数
main() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    local cmd_options=$(parse_args "$@")
    local command="$1"
    shift
    
    case "$command" in
        list)
            echo "📋 列出 MCP 服务..."
            $QODER_CLI mcp list
            ;;
        add)
            if [[ $# -lt 2 ]]; then
                echo "错误: add 命令需要名称和命令参数"
                echo "用法: $0 add <name> <command>"
                exit 1
            fi
            local name="$1"
            shift
            local cmd="$*"
            echo "🔧 添加 MCP 服务: $name"
            echo "   命令: $cmd"
            $QODER_CLI mcp add $name -- $cmd
            ;;
        remove)
            if [[ $# -lt 1 ]]; then
                echo "错误: remove 命令需要名称参数"
                echo "用法: $0 remove <name>"
                exit 1
            fi
            local name="$1"
            echo "🗑️  移除 MCP 服务: $name"
            $QODER_CLI mcp remove "$name"
            ;;
        show-config)
            echo "📁 MCP 配置文件位置:"
            echo "   用户级: $DEFAULT_MCP_DIR/.qoder.json"
            echo "   项目级: .mcp.json (在项目根目录)"
            ;;
        *)
            echo "错误: 未知命令 '$command'"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"