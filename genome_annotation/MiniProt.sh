#!/bin/bash

# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time

# cpu threads
threads=62

# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

# load quast & busco piplines via conda envirement
conda activate miniprot
genome=scaffolds_vf.sftm.fa
protein=Aves_taxid_8782_3044547_prot.fasta

# Assessing the contiguity metrics using QUAST
echo '#################################################'
echo 'Starting MiniProt alignment of signlecopy to the genome" '
echo '#################################################'

#miniprot -t62 -d genome.mpi $genome
miniprot -Iut62 --gff genome.mpi $protein > miniprot_taxid8782prot_algn.gff

stop_time=$(date +%s)
echo "Final time " $stop_time

execution_time=$(expr $stop_time - $start_time)
echo -e "Execution time " $execution_time " seconds \n "
echo -e "\t \t" $(($execution_time/60)) " minutes \n"
echo -e "\t \t" $(($execution_time/3600)) " hours \n"
