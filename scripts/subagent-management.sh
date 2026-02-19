#!/bin/bash
# Qoder CLI Subagent Management Scripts
# This script provides helper functions for managing Qoder CLI subagents

# Function to create a new subagent
create_subagent() {
    local agent_name="$1"
    local description="$2"
    local tools="$3"
    local system_prompt="$4"
    local scope="$5"  # user or project
    
    if [ -z "$agent_name" ]; then
        echo "Error: Agent name is required"
        return 1
    fi
    
    if [ "$scope" = "user" ]; then
        agent_dir="$HOME/.qoder/agents"
    else
        agent_dir="./agents"
    fi
    
    # Create agents directory if it doesn't exist
    mkdir -p "$agent_dir"
    
    # Create the subagent file
    local agent_file="$agent_dir/${agent_name}.md"
    
    cat > "$agent_file" << EOF
---
name: $agent_name
description: $description
tools: $tools
---

$system_prompt
EOF
    
    echo "Subagent '$agent_name' created successfully in $agent_file"
}

# Function to list available subagents
list_subagents() {
    local scope="$1"
    
    if [ "$scope" = "user" ]; then
        echo "User-level subagents:"
        ls -1 "$HOME/.qoder/agents/" 2>/dev/null | grep "\.md$" || echo "No user-level subagents found"
    elif [ "$scope" = "project" ]; then
        echo "Project-level subagents:"
        ls -1 "./agents/" 2>/dev/null | grep "\.md$" || echo "No project-level subagents found"
    else
        echo "User-level subagents:"
        ls -1 "$HOME/.qoder/agents/" 2>/dev/null | grep "\.md$" || echo "No user-level subagents found"
        echo ""
        echo "Project-level subagents:"
        ls -1 "./agents/" 2>/dev/null | grep "\.md$" || echo "No project-level subagents found"
    fi
}

# Function to delete a subagent
delete_subagent() {
    local agent_name="$1"
    local scope="$2"
    
    if [ "$scope" = "user" ]; then
        agent_file="$HOME/.qoder/agents/${agent_name}.md"
    else
        agent_file="./agents/${agent_name}.md"
    fi
    
    if [ -f "$agent_file" ]; then
        rm "$agent_file"
        echo "Subagent '$agent_name' deleted successfully"
    else
        echo "Error: Subagent '$agent_name' not found"
        return 1
    fi
}

# Main function to handle command line arguments
main() {
    case "$1" in
        create)
            create_subagent "$2" "$3" "$4" "$5" "$6"
            ;;
        list)
            list_subagents "$2"
            ;;
        delete)
            delete_subagent "$2" "$3"
            ;;
        *)
            echo "Usage: $0 {create|list|delete}"
            echo "  create <name> <description> <tools> <system_prompt> <scope>"
            echo "  list [scope]"
            echo "  delete <name> <scope>"
            ;;
    esac
}

# If script is called directly, run main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi