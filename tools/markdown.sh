#!/bin/bash
md2pdf() {
    # Check if a file path was provided
    if [ -z "$1" ]; then
        echo "Error: Please provide the path to the Markdown file."
        echo "Usage: md2pdf <input_file.md>"
        return 1
    fi

    local INPUT_FILE="$1"
    
    # Check if the input file exists
    if [ ! -f "$INPUT_FILE" ]; then
        echo "Error: Input file '$INPUT_FILE' not found."
        return 1
    fi

    # Check if the input file is a Markdown file (optional but good practice)
    if [[ "$INPUT_FILE" != *.md ]]; then
        echo "Warning: Input file does not have a .md extension."
    fi

    # Determine the output file name by replacing the last occurrence of .md with .pdf
    local OUTPUT_FILE="${INPUT_FILE%.md}.pdf"

    # Define your standard Pandoc options
    local PDF_ENGINE="weasyprint"
    local PANDOC_OPTIONS="--pdf-engine=$PDF_ENGINE -V geometry:margin=0pt --css $HOME/.pandoc/markdown.css"

    echo "Converting $INPUT_FILE to $OUTPUT_FILE using $PDF_ENGINE..."

    # Execute the pandoc command
    pandoc "$INPUT_FILE" -o "$OUTPUT_FILE" $PANDOC_OPTIONS

    # Check the exit status of the pandoc command
    if [ $? -eq 0 ]; then
        echo "✅ Success! PDF saved to $OUTPUT_FILE"
    else
        echo "❌ Error: Pandoc conversion failed. Check the error messages above."
    fi
}
