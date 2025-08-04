#!/bin/bash
set -e

# Initialize variables
COMMAND=""
DIRECTORY=""

# Function to show usage
show_usage() {
    echo "Usage: $0 -c|--command <command> [-d|--directory <directory>]"
    echo "Options:"
    echo "  -c, --command <command>   The command parameter to pass to claude command (required)"
    echo "  -d, --directory <dir>     The home directory path for user xsha (optional)"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --command \"Hello World\""
    echo "  $0 -c \"Hello World\" -d \"/home/custom\""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--command)
            COMMAND="$2"
            shift 2
            ;;
        -d|--directory)
            DIRECTORY="$2"
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
if [ -z "$COMMAND" ]; then
    echo "Error: --command parameter is required"
    show_usage
    exit 1
fi

# Execute claude command with optional directory change
if [ -n "$DIRECTORY" ]; then
    usermod -d "$DIRECTORY" xsha
fi

# Add the command parameter and execute
exec $COMMAND