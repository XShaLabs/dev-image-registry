#!/bin/bash
set -e

# Initialize variables
TEXT=""
DIRECTORY=""
SESSIONID=""

# Function to show usage
show_usage() {
    echo "Usage: $0 -t|--text <text> [-d|--directory <directory>] [-s|--sessionid <sessionid>]"
    echo "Options:"
    echo "  -t, --text <text>         The text parameter to pass to claude command (required)"
    echo "  -d, --directory <dir>     The home directory path for user xsha (optional)"
    echo "  -s, --sessionid <id>      Session ID to resume a conversation (optional)"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --text \"Hello World\""
    echo "  $0 -t \"Hello World\" -d \"/home/custom\""
    echo "  $0 -t \"Hello World\" -s \"session123\""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--text)
            TEXT="$2"
            shift 2
            ;;
        -d|--directory)
            DIRECTORY="$2"
            shift 2
            ;;
        -s|--sessionid)
            SESSIONID="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if required parameter is provided
if [ -z "$TEXT" ]; then
    echo "Error: --text parameter is required"
    show_usage
    exit 1
fi

# Execute claude command with optional directory change
if [ -n "$DIRECTORY" ]; then
    usermod -d "$DIRECTORY" xsha
fi

# Build claude command
CLAUDE_CMD="claude -p --output-format=stream-json --dangerously-skip-permissions --verbose"

# Add sessionid parameter if provided
if [ -n "$SESSIONID" ]; then
    CLAUDE_CMD="$CLAUDE_CMD -r $SESSIONID"
fi

# Add the text parameter and execute
exec $CLAUDE_CMD "$TEXT"