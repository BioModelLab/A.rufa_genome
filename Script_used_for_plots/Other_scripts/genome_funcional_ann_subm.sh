#!/bin/bash

# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

genome=/media/abdul/Data2TB/arufa-project/NCBI_subm/gag_output/start_stop_fixed/genome.fasta
gff_file=/media/abdul/Data2TB/arufa-project/NCBI_subm/gag_output/start_stop_fixed/genome.gff
interpro_file=/media/abdul/data/InterProScan/Inter_run181023/Inter_run9112023/A_rufa_proteins.faa.tsv
sprotfasta=/media/abdul/data/functionall_ann/sprot_db/sprot
blastsprotout=rufa_vs_sprot_blastp_corrected_ids_95.tsv
blastptreambl95=rufa_vs_trembl_blastp_corrected_ids_95.tsv
nr_file=/media/abdul/data/nr_db/nr_db/nr.fasta
uni_trEMBL=/media/abdul/data/functionall_ann/trembl_db/trembl.fasta


## Start ANNIe and adding functionnal annotation from sprot and interproscan
## converting the interproscan to a three-column annotation table 
## fixing blatp out from swisspot search to be suitable for annie.py
#python3 swiss_id.py -f1 rufa_vs_sprot_blastp_head.tsv -f2 ids_swissprot.onlyAcc_test.txt -o blastp_out_swiss_id_styl

## fixig the 9 column of the gff3 using AGAT
#agat_convert_sp_gff2gtf.pl --gff genome.gff3 -o genome.gtf
## fixing and remove duplicates from the gtf file and exporte it into corrected gff3
#agat_convert_sp_gxf2gxf.pl --gtf genome.gtf -o genome_agat.gff3
: '
filter the blastp results based on a high percent identity threshold, such as 90%.
This filtering helps focus on more accurate and relevant matches, 
leading to higher-quality functional annotations
'
#awk '{if ($3>=95) print }' rufa_vs_trembl_blastp_corrected_ids.tsv > rufa_vs_trembl_blastp_corrected_ids_95.tsv ===> wc -l 10298 genes
#awk '{if ($3>=95) print }' rufa_vs_sprot_blastp_corrected_ids.tsvb > rufa_vs_sprot_blastp_corrected_ids_95.tsv ===> wc -l 2375 genes



#how many query where common annotatated in NR and uni_trEMBL with 100 percent identity threshold = 1500 genes
## ................................................................95  percent identity threshold = 10593

### filtring the annotations based 
conda activate GAG
#annie.py -ipr $interpro_file
echo "preparing the annie annotation file from swiss prot blastp out......................................................................."
date
annie.py -b $blastsprotout -g genome.gff -db $sprotfasta -o annie_swissprot95.tsv 
date
### loading the functionall annotation from the swissprot
echo "preparing the annie annotation file from uniprot TrEMBL blastp out......................................................................."
annie.py -b $blastptreambl95 -g genome.gff -db $uni_trEMBL -o annie_trembl95.tsv 
echo "loading annotation from swiss prot......................................................................."
date
gag.py --fasta $genome --gff $gff_file --anno annie_swissprot95.tsv --out annotated_sprot
## How many genes where function annotated with actual names
tr ";*" "\n" < genome.gff | grep  '^Name='  | cut -d '=' -f2 | sort > total_named_genes.txt
date
### loading the functionall annotation from the uniprot TrEMBL
cd annotated_sprot
sudo cp ../annie_output_trembl95.tsv .
echo "loading annotation fromTrEMBL......................................................................."
date
gag.py --fasta genome.fasta --gff genome.fasta --anno annie_trembl95.tsv --out annotated_with-trembl
## How many genes where function annotated with actual names
tr ";*" "\n" < genome.gff | grep  '^Name='  | cut -d '=' -f2 | sort > total_named_genes.txt
date

### adding interpro annotation to the gff by gag
gag.py --fasta genome --gff genome.gff --anno annie_interpro_output.tsv --out annotated
### Preparing ASN file for GenBank submition
tbl2asn -i genome.fsa -p . -j "[organism=Alectoris rufa]" -V b -a a -r .



## using agat

#agat_sp_manage_functional_annotation.pl -f genome.gff -i $interpro_file --id --output agat_out
#agat_sp_manage_functional_annotation.pl -f genome.agat.interpro.gff -b rufa_vs_sprot_blastp_corrected_ids.tsv --db $sprotfasta | tee genome.agat.interpro.uniprot.final.gff


### Submisttion to the ENA

###First you need to filter and add extra information to your file otherwise submission might fail:
conda activate seqkit_env
agat_sp_flag_short_introns.pl --gff genome.gff -o genome_short_intron_flagged.gff
gff3_sp_fix_features_locations_duplicated.pl --gff genome_short_intron_flagged.gff -o genome_short_intron_flagged_duplicated_location_fixed.gff


## creating the embl flat file in order to sumbit the the genome with functional annotation
conda activate GAG
EMBLmyGFF3 genome_short_intron_flagged_duplicated_location_fixed.gff genome.fasta --data_class STD \
--topology linear --molecule_type "genomic DNA" \
--transl_table 1 \
--species "Alectoris rufa" --taxonomy "VRT" --locus_tag "U2R64" \
--project_id PRJEB67643 \
--rt "Hybrid de novo assembly using ONT Ultra-long reads polished with Illumina short-reads of the Alectoris rufa genome" \
--rg "BioModelLab" --ra "A.Eleiwa; J.Nadal; R.Alves" -o genome.embl


## Valdating embl file before submission
embl-api-validator
embl-api-validator genome.embl -f 'embl' -fix -fix_diagnose -min_gap_length 10

## Submission to ENA
java -jar webin-cli-6.6.0.jar -userName Webin-66133 \
-password Allahisone11@@ \
-context genome -manifest manifest_scaffolds.txt \
-validate -ascp -submit
## Validated submission
: 'INFO : Files have been uploaded to webin2.ebi.ac.uk. 
INFO : The submission has been completed successfully. The following analysis accession was assigned to the submission: ERZ22146366

'