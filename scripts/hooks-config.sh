#!/bin/bash
# Qoder CLI Hooks Configuration Script
# Manages notification hooks and other hook types

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS] <action>"
    echo ""
    echo "Actions:"
    echo "  create-notification-hook    Create a notification hook script"
    echo "  configure-hooks            Configure hooks in settings.json"
    echo "  list-hooks                 List configured hooks"
    echo "  test-hook                  Test a specific hook"
    echo ""
    echo "Options:"
    echo "  -w, --workspace DIR        Specify workspace directory (default: current)"
    echo "  -u, --user-level           Use user-level configuration (default: project-level)"
    echo "  -h, --help                 Show this help message"
}

# Function to get config path
get_config_path() {
    local workspace="$1"
    local user_level="$2"
    
    if [[ "$user_level" == "true" ]]; then
        echo "$HOME/.qoder/settings.json"
    else
        echo "$workspace/.qoder/settings.json"
    fi
}

# Function to ensure .qoder directory exists
ensure_qoder_dir() {
    local config_path="$1"
    local dir_path=$(dirname "$config_path")
    mkdir -p "$dir_path"
}

# Function to create notification hook script
create_notification_hook() {
    local workspace="$1"
    local hook_script="$workspace/notification.sh"
    
    cat > "$hook_script" << 'EOF'
#!/bin/bash

input=$(cat)

sessionId=$(echo $input | jq -r '.session_id')
messageInfo=$(echo $input | jq -r '.message')
workspacePath=$(echo $input | jq -r '.cwd')

if [[ "$messageInfo" =~ ^Agent ]]; then
    osascript -e 'display notification "✅ 你提交的任务执行完成啦～" with title "QoderCLI"'
else
    osascript -e 'display notification "⌛️ 你提交的任务需要授权呀…" with title "QoderCLI"'
fi

exit 0
EOF
    
    chmod +x "$hook_script"
    echo -e "${GREEN}Created notification hook script: $hook_script${NC}"
}

# Function to configure hooks in settings.json
configure_hooks() {
    local config_path="$1"
    local hook_script="$2"
    
    ensure_qoder_dir "$config_path"
    
    if [[ ! -f "$config_path" ]]; then
        # Create new config file
        cat > "$config_path" << EOF
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$hook_script"
          }
        ]
      }
    ]
  }
}
EOF
    else
        # Update existing config file
        if command -v jq &> /dev/null; then
            # Use jq to update JSON
            if [[ $(jq '.hooks // empty' "$config_path" | wc -l) -eq 0 ]]; then
                # Add hooks section
                jq --arg script "$hook_script" '.hooks = {
                  "Notification": [
                    {
                      "hooks": [
                        {
                          "type": "command",
                          "command": $script
                        }
                      ]
                    }
                  ]
                }' "$config_path" > "$config_path.tmp" && mv "$config_path.tmp" "$config_path"
            else
                # Update existing hooks
                jq --arg script "$hook_script" '.hooks.Notification[0].hooks[0].command = $script' "$config_path" > "$config_path.tmp" && mv "$config_path.tmp" "$config_path"
            fi
        else
            echo -e "${YELLOW}Warning: jq not available. Please manually add hooks to $config_path${NC}"
            return 1
        fi
    fi
    
    echo -e "${GREEN}Configured hooks in: $config_path${NC}"
}

# Function to list configured hooks
list_hooks() {
    local config_path="$1"
    
    if [[ ! -f "$config_path" ]]; then
        echo -e "${YELLOW}No hooks configuration found at: $config_path${NC}"
        return 0
    fi
    
    echo -e "${BLUE}Hooks configuration in: $config_path${NC}"
    if command -v jq &> /dev/null; then
        jq '.hooks // "No hooks configured"' "$config_path"
    else
        cat "$config_path"
    fi
}

# Function to test a hook
test_hook() {
    local hook_script="$1"
    
    if [[ ! -f "$hook_script" ]]; then
        echo -e "${RED}Hook script not found: $hook_script${NC}"
        return 1
    fi
    
    if [[ ! -x "$hook_script" ]]; then
        echo -e "${RED}Hook script is not executable: $hook_script${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Testing hook script: $hook_script${NC}"
    
    # Create test input
    cat << EOF | "$hook_script"
{
  "session_id": "test-session-123",
  "message": "Agent task completed successfully",
  "cwd": "$(pwd)"
}
EOF
    
    echo -e "${GREEN}Hook test completed${NC}"
}

# Main execution
main() {
    local workspace="$(pwd)"
    local user_level="false"
    local action=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -w|--workspace)
                workspace="$2"
                shift 2
                ;;
            -u|--user-level)
                user_level="true"
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                action="$1"
                shift
                ;;
        esac
    done
    
    if [[ -z "$action" ]]; then
        echo -e "${RED}Error: No action specified${NC}"
        usage
        exit 1
    fi
    
    local config_path=$(get_config_path "$workspace" "$user_level")
    
    case "$action" in
        create-notification-hook)
            create_notification_hook "$workspace"
            ;;
        configure-hooks)
            local hook_script="$workspace/notification.sh"
            if [[ ! -f "$hook_script" ]]; then
                create_notification_hook "$workspace"
            fi
            configure_hooks "$config_path" "$hook_script"
            ;;
        list-hooks)
            list_hooks "$config_path"
            ;;
        test-hook)
            test_hook "$workspace/notification.sh"
            ;;
        *)
            echo -e "${RED}Error: Unknown action '$action'${NC}"
            usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"