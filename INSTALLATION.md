# Installation Guide

## Prerequisites
- Linux or macOS
- Conda package manager

## Software Installation

### Data preprocessing
conda create --name qc -c bioconda fastqc fastp --yes

### Genome assembly
conda create --name assembly -c bioconda spades quast --yes

### Annotation
conda create --name annot -c bioconda blast=2.9.0 prokka=1.11.0 --yes

### Reads mapping and variant calling
conda create --name mapping -c bioconda bwa=0.7.17 samtools=1.9 qualimap=2.2.2a freebayes=0.9.21.7 bcftools=1.18 --yes