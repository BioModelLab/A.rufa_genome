#!/bin/bash

# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

conda activate genomealgn

# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time

draft=/media/abdul/Data2TB/arufa-project/assemblies/scaffolds_vf.fna


# index the draft 

#bwa-mem2 index $draft

#Aliging all short-reads to the draft assembly
threads=40
for f in $(ls *.fastq.gz | sed -e 's/_R1.fastq.gz//' -e 's/_R2.fastq.gz//' | sort -u)
do
	echo '#################################################'
	echo 'BWA-MEM2 STARTED MAPPING: ' $f
	echo '#################################################'
	
	bwa-mem2 mem -t 60 $draft ${f}_R1.fastq.gz ${f}_R2.fastq.gz | samtools sort -@ $threads -m 4G -o /media/abdul/36TB/denovo60/${f}.bam.gz -
	samtools index *.bam

	echo '#################################################'
	echo 'BWA-MEM2 COMPLETED MAPPING: ' $f
	echo '#################################################'
done




stop_time=$(date +%s)
echo "Final time " $stop_time

execution_time=$(expr $stop_time - $start_time)
echo -e "Execution time " $execution_time " seconds \n "
echo -e "\t \t" $(($execution_time/60)) " minutes \n"
echo -e "\t \t" $(($execution_time/3600)) " hours \n"