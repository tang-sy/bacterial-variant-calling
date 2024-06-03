#!/bin/bash

# Script: trimming.sh
# Description: Trim the adapter and filter low quality bases.
# Prerequisites: Fastp
# Usage: Ensure SRR_Acc_List.txt contains a list of SRA accession numbers, one per line.
#        Run scripts/trimming.sh to filter the data.

# Define the input file containing the SRA accession numbers
SRA_LIST="data/SRR_Acc_List.txt"

# Define the data folder
INPUT_FOLDER="data/sra"

# Create output folder (if necessary)
mkdir $INPUT_FOLDER/trimmed

# Loop through each SRA accession number in the input file
while read line; do
    fastp --adapter_sequence TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG \
          --adapter_sequence_r2 GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG \
          -p -c -w 2 \
          --html "$INPUT_FOLDER/trimmed/$line.fastp.html" \
          --json "$INPUT_FOLDER/trimmed/$line.fastp.json" \
          -i "$INPUT_FOLDER/${line}_1.fastq.gz" \
          -I "$INPUT_FOLDER/${line}_2.fastq.gz" \
          -o "$INPUT_FOLDER/trimmed/${line}_1.fastq.gz" \
          -O "$INPUT_FOLDER/trimmed/${line}_2.fastq.gz"
done < "$SRA_LIST"

