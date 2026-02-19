#!/bin/bash
# Qoder CLI Permission Configuration Script
# Manages permission settings for Qoder CLI

set -e

# Function to show permission configuration help
show_permission_help() {
    echo "Qoder CLI Permission Configuration"
    echo "=================================="
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --show                        Show current permissions"
    echo "  --allow PATH_PATTERN         Add allow rule"
    echo "  --deny PATH_PATTERN          Add deny rule" 
    echo "  --ask PATH_PATTERN           Add ask rule"
    echo "  --webfetch DOMAIN            Add webfetch domain restriction"
    echo "  --bash COMMAND               Add bash command restriction"
    echo "  --config-file FILE           Specify config file (default: .qoder/settings.json)"
    echo "  --project                    Use project-level config"
    echo "  --user                       Use user-level config"
    echo "  --help                       Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 --allow '/home/user/project/**' --project"
    echo "  $0 --webfetch 'example.com' --user"
    echo "  $0 --show --config-file .qoder/settings.local.json"
}

# Function to ensure config directory exists
ensure_config_dir() {
    local config_file="$1"
    local dir=$(dirname "$config_file")
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
}

# Function to initialize empty config
init_empty_config() {
    local config_file="$1"
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << EOF
{
  "permissions": {
    "ask": [],
    "allow": [],
    "deny": []
  }
}
EOF
    fi
}

# Function to add permission rule
add_permission_rule() {
    local config_file="$1"
    local rule_type="$2"
    local pattern="$3"
    
    # Ensure config exists
    ensure_config_dir "$config_file"
    init_empty_config "$config_file"
    
    # Add rule using jq
    if command -v jq >/dev/null 2>&1; then
        # Check if rule already exists
        if ! jq -e ".permissions.$rule_type[] | select(. == \"$pattern\")" "$config_file" >/dev/null 2>&1; then
            jq ".permissions.$rule_type |= . + [\"$pattern\"]" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
            echo "✅ Added $rule_type rule: $pattern"
        else
            echo "⚠️  Rule already exists: $pattern"
        fi
    else
        echo "❌ Error: jq is required for permission management"
        exit 1
    fi
}

# Function to show current permissions
show_permissions() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        echo "Current permissions in $config_file:"
        echo "=================================="
        cat "$config_file"
    else
        echo "No permission config found at $config_file"
    fi
}

# Parse arguments
CONFIG_FILE=".qoder/settings.json"
USE_PROJECT=false
USE_USER=false
SHOW=false
ALLOW=""
DENY=""
ASK=""
WEBFETCH=""
BASH_CMD=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --show)
            SHOW=true
            shift
            ;;
        --allow)
            ALLOW="$2"
            shift 2
            ;;
        --deny)
            DENY="$2"
            shift 2
            ;;
        --ask)
            ASK="$2"
            shift 2
            ;;
        --webfetch)
            WEBFETCH="$2"
            shift 2
            ;;
        --bash)
            BASH_CMD="$2"
            shift 2
            ;;
        --config-file)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --project)
            USE_PROJECT=true
            shift
            ;;
        --user)
            USE_USER=true
            shift
            ;;
        --help|-h)
            show_permission_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_permission_help
            exit 1
            ;;
    esac
done

# Determine config file path
if [ "$USE_PROJECT" = true ]; then
    CONFIG_PATH="./$CONFIG_FILE"
elif [ "$USE_USER" = true ]; then
    CONFIG_PATH="$HOME/$CONFIG_FILE"
else
    CONFIG_PATH="$CONFIG_FILE"
fi

# Handle operations
if [ "$SHOW" = true ]; then
    show_permissions "$CONFIG_PATH"
elif [ -n "$ALLOW" ]; then
    add_permission_rule "$CONFIG_PATH" "allow" "$ALLOW"
elif [ -n "$DENY" ]; then
    add_permission_rule "$CONFIG_PATH" "deny" "$DENY"
elif [ -n "$ASK" ]; then
    add_permission_rule "$CONFIG_PATH" "ask" "$ASK"
elif [ -n "$WEBFETCH" ]; then
    add_permission_rule "$CONFIG_PATH" "allow" "WebFetch(domain:$WEBFETCH)"
elif [ -n "$BASH_CMD" ]; then
    add_permission_rule "$CONFIG_PATH" "allow" "Bash($BASH_CMD)"
else
    show_permission_help
fi