#!/bin/bash

OUTPUT_DIR="docs/core"
MKDOCS_FILE="mkdocs.yml"

# Create the directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Split mkdocs.yml before and after the Geniusrise section
sed -n '1,/- Geniusrise:/p' $MKDOCS_FILE > mkdocs_part1.yml
sed -n '/#   name: null/,$p' $MKDOCS_FILE > mkdocs_part2.yml

# Function to recursively generate navigation
generate_nav() {
    local dir="$1"
    local indent="$2"

    # Loop through each item in the directory
    for item in "$dir"/*; do
        if [[ -d "$item" && ! "$item" == *test* ]]; then
            # If item is a directory, create a new section
            echo "${indent}- $(basename "$item"):" >> temp_nav.yml
            generate_nav "$item" "$indent    "
        elif [[ -f "$item" && "$item" == *.py && ! "$item" == *__init__.py && ! "$item" == *_pycache_* ]]; then
            # If item is a Python file, add it as a subsection
            local modulepath=$(echo "$item" | sed 's/\.py//; s/\.\.\/geniusrise\/geniusrise\///; s/\//./g')
            echo "::: $modulepath" > "$OUTPUT_DIR/$(echo "$modulepath" | sed 's/\./_/g').md"
            echo "${indent}- $(basename "$item" .py): core/$(echo "$modulepath" | sed 's/\./_/g').md" >> temp_nav.yml
        fi
    done
}

# Start fresh navigation section for Geniusrise in temp_nav.yml
echo "  - Geniusrise:" > temp_nav.yml
generate_nav "../geniusrise/geniusrise" "    "

# Concatenate the parts to create the updated mkdocs.yml
cat mkdocs_part1.yml temp_nav.yml mkdocs_part2.yml > $MKDOCS_FILE

# Cleanup temporary files
rm mkdocs_part1.yml mkdocs_part2.yml temp_nav.yml

echo "Markdown files generated in $OUTPUT_DIR/ and navigation updated in $MKDOCS_FILE"
