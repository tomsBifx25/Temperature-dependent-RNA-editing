#!/bin/bash
# download all samples from SRA
# should be run in the repository root directory

module load sratools

# The name of the text file containing SRA numbers (one per line, 1st column has SRA numbers)
SRA_LIST="data/ERP004763_sample_mapping.tsv"

# Check if the file exists before running
if [[ ! -f "$SRA_LIST" ]]; then
    echo "Error: File '$SRA_LIST' not found!"
    exit 1
fi

# Use a code block { } to process the file in order
{
    # Read and discard the very first line (the header)
    read -r HEADER

    # Loop through each line in the text file
    # assigns the 1st column to $SRA and dumps the rest of the row into $REMAINDER
    while IFS=$'\t' read -r SRA REMAINDER; do

        # Strip hidden carriage returns (important if the TSV was saved in Excel)
        SRA=$(echo "$SRA" | tr -d '\r')

        # Skip empty lines to prevent errors
        [[ -z "$SRA" ]] && continue

        # Check if the final compressed file already exists
        # We route errors to /dev/null so it doesn't clutter the screen if not found
        if ls data/"$SRA"*.fastq.gz >/dev/null 2>&1; then
            echo "Skipping $SRA - already completely processed."
            continue
        fi

        echo "Starting pipeline for: $SRA"

        prefetch "$SRA" --output-directory data
        fasterq-dump "data/$SRA" --outdir data -e 8 -p
        gzip "data/$SRA"*.fastq
        rm -rf "data/$SRA/"

        echo "Finished processing: $SRA"
        echo "-----------------------------------"

    done
} < "$SRA_LIST"
