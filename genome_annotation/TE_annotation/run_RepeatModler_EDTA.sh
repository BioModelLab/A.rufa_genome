#!/bin/bash
# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh


# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time

# cpu threads
threads=40
genomefile=scaffolds_vf.fa
DBname="rufa_TE"

# conda envirement where all package stored
conda activate repeatannotation
# create DB for RepeatModeler using BuildDatabase wrapper
#echo '-------------------------------------Building DB for transposable element [TE]-------------------------------------------'
BuildDatabase -name $DBname $genomefile
# Run RepeatModeler
echo '-------------------------------------Starting RepeatModeler-------------------------------------------'
RepeatModeler -database $DBname -pa 15 -LTRStruct > out.log
# the output from Rm is consensi.fa.classified

# Run using homology search using EDTA
echo '-------------------------------------Starting EDTA-------------------------------------------'

curatedlib=/media/abdul/Data2TB/annotation/repeat/EDTA/data/msRepDB_curated-aves-TEs.fasta # from close-related bird form the msRepDB
cds_closerelative=Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.cds.all.fa
EDTA=/media/abdul/Data2TB/annotation/repeat/EDTA/EDTA/EDTA.pl
perl $EDTA --genome $genomefile --curatedlib $curatedlib --cds $cds_closerelative \
--species others --step all --anno 1 -t 40 --overwrite 1 --debug 1
# the output from EDTA run let's call it msRepDB.cds.EDTA.TElib.run1.fa.fa


stop_time=$(date +%s)
echo "Final time " $stop_time

execution_time=$(expr $stop_time - $start_time)
echo -e "Execution time " $execution_time " seconds \n "
echo -e "\t \t" $(($execution_time/60)) " minutes \n"
echo -e "\t \t" $(($execution_time/3600)) " hours \n"
