#!/bin/bash
# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh
# set up timer


conda activate genomealgn
reformat.sh in=FAN30284_1_0.fastq out=FAN30284_1_0_ID_renamed.fastq trd=t
reformat.sh in=FAN30332_1_0.fastq out=FAN30332_1_0_ID_renamed.fastq trd=t
reformat.sh in=FAN30396_1_0.fastq out=FAN30396_1_0_ID_renamed.fastq trd=t
reformat.sh in=FAN53056_1_0.fastq out=FAN53056_1_0_ID_renamed.fastq trd=t

parallel --plus 'gzip {} {...}.gz' ::: *_ID_renamed.fastq


## Sumbision of the ONT raw reads to ENA

java -jar webin-cli-6.6.0.jar -userName Webin-66133 -password Allahisone11@@ -context reads -manifest manifest_FAN30102.txt -ascp -submit

java -jar webin-cli-6.6.0.jar -userName Webin-66133 -password Allahisone11@@ -context reads -manifest manifest_FAN30396_1_0.txt -ascp -submit

java -jar webin-cli-6.6.0.jar -userName Webin-66133 -password Allahisone11@@ -context reads -manifest manifest_FAN30284.txt -ascp -submit

java -jar webin-cli-6.6.0.jar -userName Webin-66133 -password Allahisone11@@ -context reads -manifest manifest_FAN30332.txt -ascp -submit

java -jar webin-cli-6.6.0.jar -userName Webin-66133 -password Allahisone11@@ -context reads -manifest manifest_FAN53056.txt -ascp -submit


### submission of genome assembly
#java -jar webin-cli-6.6.0.jar -userName Webin-66133 -password Allahisone11@@ -context genome -manifest manifest_scaffolds.txt -validate -ascp -submit