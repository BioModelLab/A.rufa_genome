#!/bin/bash

# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh
# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time

conda activate genomealgn

genome=scaffolds_vf.sftm.fa
#r=/media/abdul/data2/a.rufa_project/RNA-Seq/sra-temp/sra/SRR1664667.fastq.gz
#prefix=SRR1664667

## Index the soft-masked genome

#STAR --runThreadN 40 --runMode genomeGenerate --genomeDir index \
#--genomeFastaFiles $genome --genomeSAindexNbases 12

## Aligned raw RNASeq data to the genome
for i in /media/abdul/data2/a.rufa_project/RNA-Seq/sra-temp/sra/*.fastq.gz
do
	STAR --twopassMode Basic --genomeDir index --runThreadN 40 --readFilesIn $i --readFilesCommand zcat --outFileNamePrefix $i --outSAMtype BAM Unsorted
	samtools sort -T ./ -m 4G --threads 8 -o ${i}.sorted.bam ${i}Aligned.out.bam
	samtools index ${i}.sorted.bam
	mv ${i}.sorted.bam test/
	mv ${i}Log.final.out test/
	mv ${i}*.bai test/
	## Cleaning intermediate files
	sudo rm -r ${i}_*
	sudo rm -r ${i}Log*
	sudo rm -r ${i}SJ*
	sudo rm -r ${i}Aligned*
done



stop_time=$(date +%s)
echo "Final time " $stop_time

execution_time=$(expr $stop_time - $start_time)
echo -e "Execution time " $execution_time " seconds \n "
echo -e "\t \t" $(($execution_time/60)) " minutes \n"
echo -e "\t \t" $(($execution_time/3600)) " hours \n"
