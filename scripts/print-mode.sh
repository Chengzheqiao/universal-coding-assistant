#!/bin/bash
# Qoder CLI Print Mode Script
# Non-interactive mode for automated tasks

set -e

# Default values
OUTPUT_FORMAT="text"
MAX_TURNS=10
WORKSPACE="."

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -w|--workspace)
            WORKSPACE="$2"
            shift 2
            ;;
        --output-format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        --max-turns)
            MAX_TURNS="$2"
            shift 2
            ;;
        --allowed-tools)
            ALLOWED_TOOLS="$2"
            shift 2
            ;;
        --disallowed-tools)
            DISALLOWED_TOOLS="$2"
            shift 2
            ;;
        --yolo)
            YOLO_FLAG="--yolo"
            shift
            ;;
        *)
            PROMPT="$1"
            shift
            ;;
    esac
done

# Validate workspace
if [ ! -d "$WORKSPACE" ]; then
    echo "Error: Workspace directory '$WORKSPACE' does not exist"
    exit 1
fi

# Build command
CMD="cd '$WORKSPACE' && qodercli --print"
[ -n "$PROMPT" ] && CMD="$CMD -q '$PROMPT'"
[ -n "$OUTPUT_FORMAT" ] && CMD="$CMD --output-format=$OUTPUT_FORMAT"
[ -n "$MAX_TURNS" ] && CMD="$CMD --max-turns=$MAX_TURNS"
[ -n "$ALLOWED_TOOLS" ] && CMD="$CMD --allowed-tools=$ALLOWED_TOOLS"
[ -n "$DISALLOWED_TOOLS" ] && CMD="$CMD --disallowed-tools=$DISALLOWED_TOOLS"
[ -n "$YOLO_FLAG" ] && CMD="$CMD $YOLO_FLAG"

# Execute
eval "$CMD"