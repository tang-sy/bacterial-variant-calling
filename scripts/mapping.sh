#!/bin/bash

# Script: mapping.sh
# Description: Map the reads of 10 generation to the assembled genome.
# Prerequisites: bwa, samtools
# Usage: Run scripts/mapping.sh to filter the data.

# Create the output folder
mkdir data/mapping/sam data/mapping/bam data/mapping/stats data/mapping/q20

## index genome
$ bwa index data/assembly/scaffolds.fasta

# Loop through each generation
for i in {1..10}; do
	## mapping
	bwa mem -t 2 data/assembly/scaffolds.fasta data/sra/trimmed/evol${i}_R1.fastq.gz \
	| data/sra/trimmed/evol${i}_R2.fastq.gz > data/mapping/sam/evol${i}.sam
	## convert sam to bam
	samtools sort -n -O sam data/mapping/sam/evol${i}.sam | samtools fixmate -m -O bam - - \
	| samtools sort -O bam -o data/mapping/bam/evol${i}.sorted.bam -
	## mark duplicates
	samtools markdup -r -S data/mapping/bam/evol${i}.sorted.bam data/mapping/bam/evol${i}.sorted.dedup.bam
	## stats
	samtools flagstat data/mapping/bam/evol${i}.sorted.dedup.bam > data/mapping/stats/evol${i}.stats.txt
	## depth
	samtools depth data/mapping/bam/evol${i}.sorted.dedup.bam | gzip > data/mapping/stats/evol${i}.depth.txt.gz
	## quality filtering
	samtools view -h -b -q 20 data/mapping/bam/evol${i}.sorted.dedup.bam > data/mapping/q20/evol${i}.sorted.dedup.q20.bam
done
