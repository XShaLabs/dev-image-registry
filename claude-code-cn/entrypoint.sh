#!/bin/bash
set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory> <text>"
    echo "  directory: The home directory path for user xsha"
    echo "  text: The text parameter to pass to claude command"
    exit 1
fi

DIRECTORY="$1"
TEXT="$2"

sudo usermod -d "$DIRECTORY" xsha
exec sudo -u xsha claude -p --output-format=stream-json --dangerously-skip-permissions --verbose "$TEXT"