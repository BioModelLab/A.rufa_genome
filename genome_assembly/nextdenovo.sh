#!/bin/bash

# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time

# cpu threads
threads=40


conda activate genomealgn
nextDenovo run.cfg
stop_time=$(date +%s)
echo "Final time " $stop_time

execution_time=$(expr $stop_time - $start_time)
echo -e "Execution time " $execution_time " seconds \n "
echo -e "\t \t" $(($execution_time/60)) " minutes \n"
echo -e "\t \t" $(($execution_time/3600)) " hours \n"
