# Genome annotation
The assembled genom were annotated using a combination methods:
- Evidance from proteins sequences from close related species
- Transcriptome from RNAseq were used
- ab-initio were trained using external evidance (protein sequences)


## Requirements
1. Setting conda envirment
We prepared a bash script in order to help you setting up an inviremmnt usin conda
```
sh conda_setup.sh
```
2. Docker
3. Thirds part


## Proteins-based

```
conda activate miniprot
genome=$genome_sf_masked_file
protein=Aves_taxid_8782_3044547_prot.fasta
miniprot -Iut62 --gff genome.mpi $protein > miniprot_taxid8782prot_algn.gff
conda deactivate
```
## Transcriptom-based
```
docker run --rm -it \
    -v /media/abdul/Data2TB/arufa-project/annotation/pasaann/tmp:/tmp \
    -v /media/abdul/Data2TB/arufa-project/annotation/pasaann:/data \
    pasapipeline/pasapipeline:latest \
    bash -c 'cd /data && \
        /usr/local/src/PASApipeline/Launch_PASA_pipeline.pl \
            -c sqlite.confs/alignAssembly.config -C -R \
            --ALIGNER gmap -g $genome_sf_masked_file -t $transcriptom_assembly '
```