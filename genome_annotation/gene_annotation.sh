#!/bin/bash
# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

# set up timer
start_time=$(date +%s)
echo "Initial time " $start_time

# cpu threads
threads=70
genome_sf_masked_file=scaffolds_vf.sftm.fa
transcriptom_assembly=
miniprot_gff=
PASAgff=
BRAKER2gff=

echo "## -1 Homology-based : Proteins seq from close-related ##"

## Dowloding proteom seq availlabe at NCBI related to the Aves taxa_id 8782: by Apr of 2023
esearch -db protein -query "Aves [ORGN] AND refseq [filter]" | efetch -format fasta > Aves_taxid_8782_3044547_prot.fasta

echo "···················Strating annotation with Miniprot........................"
conda activate miniprot
genome=$genome_sf_masked_file
protein=Aves_taxid_8782_3044547_prot.fasta
miniprot -Iut62 --gff genome.mpi $protein > miniprot_taxid8782prot_algn.gff
conda deactivate
echo "····················MiniProt completd......................................."

echo "## -2 Transcriptome-based : PASA approach ##"

echo "···················Strating annotation with PASApipeline........................"
date
docker run --rm -it \
    -v /media/abdul/Data2TB/arufa-project/annotation/pasaann/tmp:/tmp \
    -v /media/abdul/Data2TB/arufa-project/annotation/pasaann:/data \
    pasapipeline/pasapipeline:latest \
    bash -c 'cd /data && \
        /usr/local/src/PASApipeline/Launch_PASA_pipeline.pl \
            -c sqlite.confs/alignAssembly.config -C -R \
            --ALIGNER gmap -g $genome_sf_masked_file -t $transcriptom_assembly '

echo "····················PASApipline completd......................................."
date




conda activate braker3-deps2
proteins=Prot.MetaEuk.faa

echo "## -3 ab-initio : BRAKER2 ##"

echo "···················Strating annotation with BRAKER2........................"
date

conda activate braker3-deps2
braker.pl --cores $threads --gff3 --genome=$genome_sf_masked_file --species=Alectoris-rufa --prot_seq=$protein \
--softmasking --workingdir=braker2 --useexisting --PROTHINT_PATH=/home/abdul/gmes_linux_64/ProtHint/bin
conda deactivate
echo "····················BRAKER2 completd......................................."
date
mkdir EVM_run
cp braker.gff3 EVM_run

echo "## -4 Combining annotation : EVIDENCEMODELER ##"
echo "···················Combing all annotation with EVM........................"
date
docker run --rm  -v "$(pwd)":/data brianjohnhaas/evidencemodeler:latest \
       bash -c 'cd /data && EVidenceModeler --sample_id A_rufa \
                   --genome $genome_sf_masked_file \
                   --weights ./aug_minaves_transc_weights.txt \
                   --gene_predictions $BRAKER2gff \
                   --protein_alignments $miniprot_gff \
                   --transcript_alignments $PASAgff \
                   --segmentSize 1000000 \
                   --overlapSize 10000 \
                   --CPU $threads '

      
echo "Done. See A_rufa.EVM.* outputs"
echo "···················EVM completed........................"
date





stop_time=$(date +%s)
echo "Final time " $stop_time

execution_time=$(expr $stop_time - $start_time)
echo -e "Execution time " $execution_time " seconds \n "
echo -e "\t \t" $(($execution_time/60)) " minutes \n"
echo -e "\t \t" $(($execution_time/3600)) " hours \n"

Spain
