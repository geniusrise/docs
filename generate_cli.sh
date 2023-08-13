#!/bin/bash

# Directory containing your project's Python files
PROJECT_DIR="../geniusrise/geniusrise"

# Directory to store generated markdown files
OUTPUT_DIR="docs/cli"

# Create the directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Use find to get the list of Python files and loop through each file
find $PROJECT_DIR -name "*.py" | while read -r filepath; do
    # Check if the file uses argparse
    if grep -q "import argparse" "$filepath"; then
        # Extract a suitable name for the markdown file from the Python file path
        md_filename=$(echo "$filepath" | sed 's/\.py/.md/; s/.*\///')
        # Generate markdown documentation using argparse-md
        argmark -f "$filepath" > "$OUTPUT_DIR/$md_filename"
        echo "Generated documentation for $filepath"
    fi
done

echo "Markdown files generated in $OUTPUT_DIR/"
