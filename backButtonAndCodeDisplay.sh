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


# Regular expression to match the diagnosis code (Code F400) within the page
#regex='<mark class="highlight-gray"><mark class="highlight-gray_background">\\(Code[^)]*\\)<\/mark><\/mark>'
regex='<mark class="highlight-gray"><mark class="highlight-gray_background">\(Code[^)]*\)</mark></mark>'



# Loop through all HTML files in the current directory
find "$target_directory" -type f -name "*.html" | while read file; do

    # Use grep to find the first match of the regular expression in the file
    match=$(grep -oP "$regex" "$file" | head -1)
    #match=$(awk '/'"$regex"'/{print; exit}' "$file")


    

    #echo $file
    
    if [ ! -z "$match" ]; then
         # Use sed to remove the first occurrence of the match in the file

         escaped_match=$(printf '%s\n' "$match" | sed -e 's/[\/&]/\\&/g' -e 's/\./\\./g' -e 's/"/\\"/g' -e 's/</\\</g' -e 's/>/\\>/g')

        echo $escaped_match
  
         sed -i "s#$escaped_match##g" "$file"

         # Use sed to insert the back button and the diagnosis code just before the title

         #sed -i "s/<title>/<button style=\"margin-bottom:20px\" onclick=\"window.history.back();\">retour</button>&nbsp;&nbsp;$match<title>/" "$file"

    # else
    #     # If no diagnosis code found, just insert the back button
    #     sed -i "s/<title>/<button style=\"margin-bottom:20px\" onclick=\"window.history.back();\">retour</button> /" "$file"
    fi
        
    
done