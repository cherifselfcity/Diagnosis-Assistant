#!/bin/bash

# Path to the HTML content to be inserted
INSERT_FILE="HandleParamsScript.html"

# Check if the insert file exists
if [ ! -f "$INSERT_FILE" ]; then
    echo "Error: File '$INSERT_FILE' not found!"
    exit 1
fi

# Read and prepare the content for insertion from the HTML file
# Convert the content to a single line with encoded newlines
CONTENT=$(awk '{printf "%s\\n", $0}' "$INSERT_FILE" | awk '{gsub(/\\n$/, ""); print}')

# Use find to iterate over all html files in the current directory and subdirectories
find . -type f -name "*.html" -print0 | while IFS= read -r -d '' file; do
    # Using awk to insert CONTENT after the <body> tag
    awk -v content="$CONTENT" 'BEGIN { ORS=""; print }
        /<body[^>]*>/ { print; print content; next }
        { print $0 "\n" }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
done

echo "Insertion complete."
