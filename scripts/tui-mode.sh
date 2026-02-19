#!/bin/bash
# Qoder CLI TUI Mode Script
# Launch Qoder CLI in TUI (interactive) mode

set -e

PROJECT_DIR="${1:-.}"
shift

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory '$PROJECT_DIR' does not exist"
    exit 1
fi

cd "$PROJECT_DIR"

# Launch Qoder CLI in TUI mode with any additional arguments
qodercli "$@"