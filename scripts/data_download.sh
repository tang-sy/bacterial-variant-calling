#!/bin/bash

# Script: download_data.sh
# Description: Downloads data from the NCBI Sequence Read Archive (SRA) using fasterq-dump.
# Prerequisites: NCBI SRA Toolkit (fasterq-dump)
# Usage: Ensure SRR_Acc_List.txt contains a list of SRA accession numbers, one per line.
#        Run scripts/download_data.sh to download and compress the data.

# Define the input file containing the SRA accession numbers
SRA_LIST="data/SRR_Acc_List.txt"

# Define the output folder
OUTPUT_FOLDER="data/sra"

# Loop through each SRA accession number in the input file
while read -r line; do
    # Download the data using fasterq-dump
    fasterq-dump -e 4 --split-3 -O "$OUTPUT_FOLDER" "$line"
    
    # Compress the downloaded files
    gzip "$OUTPUT_FOLDER/${line}_1.fastq"
    gzip "$OUTPUT_FOLDER/${line}_2.fastq"
done < "$SRA_LIST"

