#!/bin/bash
# Qoder CLI Memory Management Scripts
# Manages AGENTS.md memory files for user and project levels

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to initialize memory file in current project
init_project_memory() {
    local project_dir="${1:-$(pwd)}"
    local memory_file="$project_dir/AGENTS.md"
    
    if [ ! -f "$memory_file" ]; then
        echo "Creating project memory file: $memory_file"
        cat > "$memory_file" << EOF
# AGENTS.md - Project Memory

## Project Context
- **Project Name**: $(basename "$project_dir")
- **Description**: 
- **Tech Stack**: 
- **Key Components**: 

## Development Guidelines
- **Code Style**: 
- **Testing Requirements**: 
- **Deployment Process**: 

## Important Notes
- 

EOF
        echo -e "${GREEN}Project memory file created successfully!${NC}"
    else
        echo -e "${YELLOW}Project memory file already exists: $memory_file${NC}"
    fi
}

# Function to initialize user-level memory
init_user_memory() {
    local qoder_dir="$HOME/.qoder"
    local memory_file="$qoder_dir/AGENTS.md"
    
    mkdir -p "$qoder_dir"
    
    if [ ! -f "$memory_file" ]; then
        echo "Creating user memory file: $memory_file"
        cat > "$memory_file" << EOF
# AGENTS.md - User Memory

## Personal Preferences
- **Preferred Tech Stack**: 
- **Coding Style**: 
- **Common Tools**: 

## Workflow Guidelines
- **Project Setup**: 
- **Debugging Approach**: 
- **Documentation Standards**: 

## Reusable Knowledge
- 

EOF
        echo -e "${GREEN}User memory file created successfully!${NC}"
    else
        echo -e "${YELLOW}User memory file already exists: $memory_file${NC}"
    fi
}

# Function to edit memory file
edit_memory() {
    local memory_type="$1"  # user or project
    local project_dir="${2:-$(pwd)}"
    
    case "$memory_type" in
        "user")
            local memory_file="$HOME/.qoder/AGENTS.md"
            ;;
        "project")
            local memory_file="$project_dir/AGENTS.md"
            ;;
        *)
            echo -e "${RED}Error: Invalid memory type. Use 'user' or 'project'.${NC}"
            return 1
            ;;
    esac
    
    if [ ! -f "$memory_file" ]; then
        echo -e "${YELLOW}Memory file not found. Creating...${NC}"
        if [ "$memory_type" = "user" ]; then
            init_user_memory
        else
            init_project_memory "$project_dir"
        fi
    fi
    
    echo "Opening memory file for editing: $memory_file"
    ${EDITOR:-nano} "$memory_file"
}

# Function to view memory file
view_memory() {
    local memory_type="$1"  # user or project
    local project_dir="${2:-$(pwd)}"
    
    case "$memory_type" in
        "user")
            local memory_file="$HOME/.qoder/AGENTS.md"
            ;;
        "project")
            local memory_file="$project_dir/AGENTS.md"
            ;;
        *)
            echo -e "${RED}Error: Invalid memory type. Use 'user' or 'project'.${NC}"
            return 1
            ;;
    esac
    
    if [ -f "$memory_file" ]; then
        echo "=== $memory_type Memory File ==="
        cat "$memory_file"
    else
        echo -e "${YELLOW}Memory file not found: $memory_file${NC}"
    fi
}

# Main function
main() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "  init-project    Initialize project memory file"
        echo "  init-user       Initialize user memory file"
        echo "  edit <type>     Edit memory file (user|project)"
        echo "  view <type>     View memory file (user|project)"
        echo ""
        echo "Examples:"
        echo "  $0 init-project"
        echo "  $0 edit project"
        echo "  $0 view user"
        return 1
    fi
    
    case "$1" in
        "init-project")
            init_project_memory "${2:-$(pwd)}"
            ;;
        "init-user")
            init_user_memory
            ;;
        "edit")
            if [ $# -lt 2 ]; then
                echo -e "${RED}Error: Missing memory type (user|project)${NC}"
                return 1
            fi
            edit_memory "$2" "${3:-$(pwd)}"
            ;;
        "view")
            if [ $# -lt 2 ]; then
                echo -e "${RED}Error: Missing memory type (user|project)${NC}"
                return 1
            fi
            view_memory "$2" "${3:-$(pwd)}"
            ;;
        *)
            echo -e "${RED}Error: Unknown command '$1'${NC}"
            return 1
            ;;
    esac
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi