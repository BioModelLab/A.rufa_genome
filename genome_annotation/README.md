# Genome annotation
The assembled genom were annotated using a combination methods:
- Proteins-based prediction using a sef of proteins sequences downloaded from the **NCBI**
- Transcriptome-based methods using the RNAseq from the Biosample **SAMN03846984**  available at the [NCBI SRA](https://www.ncbi.nlm.nih.gov/biosample/SAMN03846984)
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
## ab-initio prediction
```
conda activate braker3-deps2
braker.pl --cores 70 --gff3 --genome=$genome --species=Alectoris-rufa --prot_seq=$proteins \
--softmasking --workingdir=braker2 --useexisting --PROTHINT_PATH=/home/abdul/gmes_linux_64/ProtHint/bin
conda deactivate

```