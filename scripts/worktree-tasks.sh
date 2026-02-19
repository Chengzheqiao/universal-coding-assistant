#!/bin/bash
# Qoder CLI Worktree Tasks Management Scripts
# This script provides functions to manage worktree tasks in Qoder CLI

# Create a new worktree task
create_worktree_task() {
    local job_description="$1"
    local branch="$2"
    local non_interactive="$3"
    
    if [ -z "$job_description" ]; then
        echo "Error: Job description is required"
        echo "Usage: create_worktree_task \"job description\" [branch] [non_interactive]"
        return 1
    fi
    
    local cmd="qodercli --worktree \"$job_description\""
    
    # Add branch option if provided
    if [ -n "$branch" ]; then
        cmd="$cmd --branch $branch"
    fi
    
    # Add non-interactive mode if requested
    if [ "$non_interactive" = "true" ]; then
        cmd="$cmd -p"
    fi
    
    echo "Creating worktree task: $job_description"
    eval $cmd
}

# List all worktree tasks
list_worktree_tasks() {
    echo "Listing all worktree tasks..."
    qodercli jobs --worktree
}

# Remove a worktree task
remove_worktree_task() {
    local job_id="$1"
    
    if [ -z "$job_id" ]; then
        echo "Error: Job ID is required"
        echo "Usage: remove_worktree_task <job_id>"
        return 1
    fi
    
    echo "Removing worktree task: $job_id"
    qodercli rm "$job_id"
}

# Get worktree task status
get_worktree_status() {
    local job_id="$1"
    
    if [ -z "$job_id" ]; then
        echo "Error: Job ID is required"
        echo "Usage: get_worktree_status <job_id>"
        return 1
    fi
    
    echo "Getting status for worktree task: $job_id"
    qodercli jobs --worktree | grep "$job_id"
}

# Helper function to validate worktree environment
validate_worktree_env() {
    if ! command -v git &> /dev/null; then
        echo "Error: Git is required for worktree tasks but not found"
        return 1
    fi
    
    if ! command -v qodercli &> /dev/null; then
        echo "Error: Qoder CLI is not installed or not in PATH"
        return 1
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Must be in a git repository to use worktree tasks"
        return 1
    fi
}

# Export functions for use in other scripts
export -f create_worktree_task
export -f list_worktree_tasks  
export -f remove_worktree_task
export -f get_worktree_status
export -f validate_worktree_env