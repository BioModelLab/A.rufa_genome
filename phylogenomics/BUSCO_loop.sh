#!/bin/bash

# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time
# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh
#. /home/abdul/mambaforge/etc/profile.d/conda.sh



# Assessing the completness of the assembly using BUSCO
echo '#################################################'
echo 'Starting BUSCO "Benchmarking Universal Single-Copy Orthologs" '
echo '#################################################'


conda activate busco
#contigs

threads=48
inputfasta=/media/abdul/Data2TB/arufa-project/synteny/Aves/ASSEMBLY/
for genome in $inputfasta/*.fasta
do
	echo "Runing BUSCO search of ${genome} "
	busco --offline -i $genome -o ${genome}_busco -m genome -c $threads -l /home/abdul/Desktop/busco_downloads/lineages/aves_odb10
	generate_plot.py -wd ./${genome}_busco/
done


echo '#################################################'
echo 'Finished BUSCO completness score and report saved to' 
pwd
echo '#################################################'


stop_time=$(date +%s)
echo "Final time " $stop_time

execution_time=$(expr $stop_time - $start_time)
echo -e "Execution time " $execution_time " seconds \n "
echo -e "\t \t" $(($execution_time/60)) " minutes \n"
echo -e "\t \t" $(($execution_time/3600)) " hours \n"