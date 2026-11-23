#!/bin/bash

# Injecte HandleParamsScript.html juste après <body> dans chaque page de l'export Notion.
# Relançable : le bloc déjà injecté (balisé, ou l'ancienne version sans balises) est
# d'abord retiré, puis remplacé par la version courante de HandleParamsScript.html.

set -euo pipefail
cd "$(dirname "$0")"

# Path to the HTML content to be inserted
INSERT_FILE="HandleParamsScript.html"

# Check if the insert file exists
if [ ! -f "$INSERT_FILE" ]; then
    echo "Error: File '$INSERT_FILE' not found!"
    exit 1
fi

SELFCITY_CONTENT=$(cat "$INSERT_FILE")
export SELFCITY_CONTENT

count=0
while IFS= read -r -d '' file; do
    perl -0777 -i -pe '
        # Bloc balisé, injecté par ce script
        s/\n?<!-- selfcity:handle-params:start -->.*?<!-- selfcity:handle-params:end -->\n?//gs;
        # Ancien bloc, injecté sans balises à la fin de la ligne de <body>
        s/<script>\s*\/\/ Wait for the DOM to fully load.*?<\/script>\n*/\n/gs;
        # Bloc courant, juste après la balise <body>
        s/(<body[^>]*>)/$1\n$ENV{SELFCITY_CONTENT}\n/;
    ' "$file"
    count=$((count + 1))
done < <(find . -type f -name "*.html" -not -path "./.git/*" -not -name "$INSERT_FILE" -print0)

echo "Insertion complete ($count pages)."
