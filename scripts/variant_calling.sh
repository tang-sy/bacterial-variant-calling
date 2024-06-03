#!/bin/bash

# Script: variant_calling.sh
# Description: Call variants of 10 generation referring to the assembled genome.
# Prerequisites: samtools, bamtools, freebayes, tabix, rtg-tools
# Usage: Run scripts/variant_calling.sh to call variants.

# Create output directory
mkdir data/variants data/variants/vcf data/variants/stats data/variants/plots data/variants/q30

# Loop through each generations
for i in {1..10}; do
	## index bam files
	bamtools index -in data/mapping/q20/evol${i}.sorted.dedup.q20.bam
	## variant calling
	freebayes -p 1 -f data/assembly/scaffolds.fasta \
	data/mapping/q20/evol${i}.sorted.dedup.q20.bam \
	> data/variants/vcf/evol${i}.freebayes.vcf
	## compress vcf files
	bgzip data/variants/vcf/evol${i}.freebayes.vcf
	## index vcf files
	tabix -p vcf data/variants/vcf/evol${i}.freebayes.vcf.gz
	## get basic statistics
	rtg vcfstats data/variants/vcf/evol${i}.freebayes.vcf.gz \
	> data/variants/stats/evol${i}.freebayes.vcf.stats
	## filter variants quality>30
	rtg vcffilter -q 30 -i data/variants/vcf/evol${i}.freebayes.vcf.gz \
	-o data/variants/q30/evol${i}.freebayes.q30.vcf.gz
done