#!/bin/bash
set -e

if [ $# -eq 1 ]; then
    TEXT="$1"
    exec claude -p --output-format=stream-json --dangerously-skip-permissions --verbose "$TEXT"
elif [ $# -eq 2 ]; then
    DIRECTORY="$1"
    TEXT="$2"
    sudo usermod -d "$DIRECTORY" xsha
    exec claude -p --output-format=stream-json --dangerously-skip-permissions --verbose "$TEXT"
else
    echo "Usage: $0 <text>"
    echo "   or: $0 <directory> <text>"
    echo "  text: The text parameter to pass to claude command"
    echo "  directory: The home directory path for user xsha (optional)"
    exit 1
fi