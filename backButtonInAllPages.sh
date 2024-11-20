#!/bin/bash

# Find the directory starting with "Assistant racine" within the current directory
target_directory=$(find . -maxdepth 1 -type d -name "🤖 Assistant racine*" -print -quit)

# Check if the directory was found
if [ -z "$target_directory" ]; then
    echo "Directory not found."
    exit 1
fi

echo "Found directory: $target_directory"

# Perform find and replace
find "$target_directory" -type f -name '*.html' -exec sed -i '' 's|<title>|<button style="margin-bottom:20px" onclick="window.history.back();">retour</button><title>|g' {} +
