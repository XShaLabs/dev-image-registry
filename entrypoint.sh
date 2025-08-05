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

# Copy files from specified directory to /home/xsha if directory parameter is provided
if [ -n "$DIRECTORY" ]; then
    # Ensure the source directory exists
    if [ -d "$DIRECTORY" ]; then
        # Copy all files (including hidden files) from source directory to /home/xsha
        # Using cp -rf to recursively copy and force overwrite existing files
        cp -rf "$DIRECTORY"/. "/home/xsha"/
        echo "Copied files from $DIRECTORY to /home/xsha"
    else
        echo "Warning: Directory $DIRECTORY does not exist, skipping copy operation"
    fi
fi

# Add the command parameter and execute
exec $COMMAND

# Copy files from /home/xsha to specified directory if provided
if [ -n "$DIRECTORY" ]; then    
    # Copy all files (including hidden files) from /home/xsha to target directory
    # Using cp -rf to recursively copy and force overwrite existing files
    if [ -d "/home/xsha" ]; then
        cp -rf /home/xsha/. "$DIRECTORY"/
    fi
fi