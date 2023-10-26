#!/bin/bash

# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

echo "Triming adapters with Porechop"
date
conda activate genomeasses
fastq_file=all5ont.fq.gz
porechop -i $fastq_file -o ${all5ont}.trimmed.fastq.gz --threads 40
echo "Triming adapters with Porechop completed"
date

echo 'Starting Filtlong for generating two subset of for genome polishing and scaffolding'
echo 'generation 40X from the ONT raw reads'
filtlong --min_length 10000 -p 90 -t 40000000000 {all5ont}.trimmed.fastq.gz | gzip > {all5ont}.trimmed.filtred.10kb.fq.gz

echo 'generation 20X from the ONT raw reads'
filtlong --min_mean_q 12.0 -t 20000000000 {all5ont}.trimmed.fastq.gz | gzip > {all5ont}.trimmed.filtred.12q.fq.gz
echo 'Finished Filtlong resulted output saved to ' 


echo "····················Assesing the QC of ONT raw reads using NanoPlot ........................"
date
conda activate ontseqkit
echo 'QC of 40X from the ONT raw reads'
NanoPlot --fastq {all5ont}.trimmed.filtred.10kb.fq.gz -o qc_trimmed.filtred.10kb
echo 'QC 20X from the ONT raw reads'
NanoPlot --fastq {all5ont}.trimmed.filtred.12q.fq.gz -o qc_trimmed.filtred.12q
echo "····················Assesing the QC of ONT raw reads using NanoPlot completed...................."
data