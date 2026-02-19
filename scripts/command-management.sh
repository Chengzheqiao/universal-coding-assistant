#!/bin/bash
# Qoder CLI Command Management Script
# Manages user and project level commands

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  create-user <name> <description>     Create a user-level command"
    echo "  create-project <name> <description>  Create a project-level command"
    echo "  list-user                           List all user-level commands"
    echo "  list-project                        List all project-level commands"
    echo "  edit-user <name>                    Edit a user-level command"
    echo "  edit-project <name>                 Edit a project-level command"
    echo "  delete-user <name>                  Delete a user-level command"
    echo "  delete-project <name>               Delete a project-level command"
    echo ""
    echo "Examples:"
    echo "  $0 create-user quest \"Intelligent workflow orchestrator\""
    echo "  $0 list-project"
}

# Function to create command directory if it doesn't exist
create_command_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo -e "${GREEN}Created directory: $dir${NC}"
    fi
}

# Function to create a command file
create_command_file() {
    local file_path="$1"
    local name="$2"
    local description="$3"
    
    if [ -f "$file_path" ]; then
        echo -e "${YELLOW}Command file already exists: $file_path${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipped."
            return 1
        fi
    fi
    
    cat > "$file_path" << EOF
---
description: "$description"
---

# Add your command prompt here
# This will be executed when you type /$name in TUI mode

EOF
    
    echo -e "${GREEN}Created command: $file_path${NC}"
}

# Main script logic
if [ $# -eq 0 ]; then
    usage
    exit 1
fi

case "$1" in
    "create-user")
        if [ $# -ne 3 ]; then
            echo -e "${RED}Error: create-user requires name and description${NC}"
            usage
            exit 1
        fi
        COMMAND_NAME="$2"
        DESCRIPTION="$3"
        USER_COMMANDS_DIR="$HOME/.qoder/commands"
        create_command_dir "$USER_COMMANDS_DIR"
        create_command_file "$USER_COMMANDS_DIR/${COMMAND_NAME}.md" "$COMMAND_NAME" "$DESCRIPTION"
        ;;
        
    "create-project")
        if [ $# -ne 3 ]; then
            echo -e "${RED}Error: create-project requires name and description${NC}"
            usage
            exit 1
        fi
        COMMAND_NAME="$2"
        DESCRIPTION="$3"
        PROJECT_COMMANDS_DIR="./commands"
        create_command_dir "$PROJECT_COMMANDS_DIR"
        create_command_file "$PROJECT_COMMANDS_DIR/${COMMAND_NAME}.md" "$COMMAND_NAME" "$DESCRIPTION"
        ;;
        
    "list-user")
        USER_COMMANDS_DIR="$HOME/.qoder/commands"
        if [ -d "$USER_COMMANDS_DIR" ]; then
            echo "User-level commands:"
            ls -1 "$USER_COMMANDS_DIR"/*.md 2>/dev/null | xargs -I {} basename {} .md
        else
            echo "No user-level commands found."
        fi
        ;;
        
    "list-project")
        PROJECT_COMMANDS_DIR="./commands"
        if [ -d "$PROJECT_COMMANDS_DIR" ]; then
            echo "Project-level commands:"
            ls -1 "$PROJECT_COMMANDS_DIR"/*.md 2>/dev/null | xargs -I {} basename {} .md
        else
            echo "No project-level commands found."
        fi
        ;;
        
    "edit-user")
        if [ $# -ne 2 ]; then
            echo -e "${RED}Error: edit-user requires command name${NC}"
            usage
            exit 1
        fi
        COMMAND_NAME="$2"
        USER_COMMANDS_FILE="$HOME/.qoder/commands/${COMMAND_NAME}.md"
        if [ -f "$USER_COMMANDS_FILE" ]; then
            ${EDITOR:-nano} "$USER_COMMANDS_FILE"
        else
            echo -e "${RED}Command not found: $USER_COMMANDS_FILE${NC}"
            exit 1
        fi
        ;;
        
    "edit-project")
        if [ $# -ne 2 ]; then
            echo -e "${RED}Error: edit-project requires command name${NC}"
            usage
            exit 1
        fi
        COMMAND_NAME="$2"
        PROJECT_COMMANDS_FILE="./commands/${COMMAND_NAME}.md"
        if [ -f "$PROJECT_COMMANDS_FILE" ]; then
            ${EDITOR:-nano} "$PROJECT_COMMANDS_FILE"
        else
            echo -e "${RED}Command not found: $PROJECT_COMMANDS_FILE${NC}"
            exit 1
        fi
        ;;
        
    "delete-user")
        if [ $# -ne 2 ]; then
            echo -e "${RED}Error: delete-user requires command name${NC}"
            usage
            exit 1
        fi
        COMMAND_NAME="$2"
        USER_COMMANDS_FILE="$HOME/.qoder/commands/${COMMAND_NAME}.md"
        if [ -f "$USER_COMMANDS_FILE" ]; then
            rm -i "$USER_COMMANDS_FILE"
            echo -e "${GREEN}Deleted user command: $COMMAND_NAME${NC}"
        else
            echo -e "${RED}Command not found: $USER_COMMANDS_FILE${NC}"
            exit 1
        fi
        ;;
        
    "delete-project")
        if [ $# -ne 2 ]; then
            echo -e "${RED}Error: delete-project requires command name${NC}"
            usage
            exit 1
        fi
        COMMAND_NAME="$2"
        PROJECT_COMMANDS_FILE="./commands/${COMMAND_NAME}.md"
        if [ -f "$PROJECT_COMMANDS_FILE" ]; then
            rm -i "$PROJECT_COMMANDS_FILE"
            echo -e "${GREEN}Deleted project command: $COMMAND_NAME${NC}"
        else
            echo -e "${RED}Command not found: $PROJECT_COMMANDS_FILE${NC}"
            exit 1
        fi
        ;;
        
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        usage
        exit 1
        ;;
esac