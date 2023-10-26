#!/bin/bash

# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time

# cpu threads
threads=40

# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

# load quast & busco piplines via conda envirement
conda activate genomealgn

input=$1
q
echo '#################################################'
echo 'Starting BUSCO "Benchmarking Universal Single-Copy Orthologs" '
echo '#################################################'

busco_out=$2
conda activate genomeasses
busco --offline -i $input -o $busco_out -m prot -c $threads -l /home/abdul/Desktop/busco_downloads/lineages/aves_odb10 

# aves_odb10 the avian orthologos databases
# generate plot
generate_plot.py -wd ./$busco_out/
#Print overall time for running the pipline in (sec, min and hours)
conda deactivate

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
