#!/bin/bash


# Add miniconda3 to PATH
. /home/abdul/anaconda3/etc/profile.d/conda.sh

## Remove redundancy of annotated transposons element by EDTA + mRepDB
awk 'BEGIN {i = 1;} { if ($1 ~ /^>/) { tmp = h[i]; h[i] = $1; } else if (!a[$1]) { s[i] = $1; a[$1] = "1"; i++; } else { h[i] = tmp; } } END { for (j = 1; j < i; j++) { print h[j]; print s[j]; } }' < msRepDB.cds.EDTA.TElib.run1.fa.fa > uniq-EDTA-lib.fa
## basic stats 
grep ">" msRepDB.cds.EDTA.TElib.run1.fa.fa|wc -l
#7072
grep ">" uniq-EDTA-lib.fa|wc -l
#5598

## Remove redundancy from the custom transposons element de novo predicted by RepeatModeler
awk 'BEGIN {i = 1;} { if ($1 ~ /^>/) { tmp = h[i]; h[i] = $1; } else if (!a[$1]) { s[i] = $1; a[$1] = "1"; i++; } else { h[i] = tmp; } } END { for (j = 1; j < i; j++) { print h[j]; print s[j]; } }' < consensi.fa.classified > uniq-RM-lib.fa
## basic stats
grep ">" consensi.fa.classified|wc -l
378
grep ">" uniq-RM-lib.fa|wc -l
371
## 7 redunadancy element in the RM TE lib

## Remove misannotated (tRNA(65), scRNA(4) snRNA(12)) from EDTA uniq lib of transpososns element
## Remove MITE (Miniature inverted repeat transposable elements)
## Remove all DNA class whitout annotated transposons element type
## Remove all Artefact sequence or any suspicious sequence (DNA?, Simple_repeat,_INT, _MITE, Satellite)
grep "^>" uniq-EDTA-lib.fa > uniq-EDTA-lib-headers-list.txt # get the list of head title of EDTA-lib-heads.txt
## filtring to remove all mentioned above list using uniq-EDTA-lib-headers-list.txt > cleaned-uniq-EDTA-lib-headers-list.txt
## The extract only known annotation listed in uniq-EDTA-lib-headers-list.txt using faSomeRecords
./faSomeRecords filtred-EDTA.fa selected-EDTA-TE.txt curated-EDTA.fa
## Then combined all methods mentioned above in one library file 
cat filtred-EDTA.fa uniq-RM-lib.fa > combined-TE-lib.fa

## Then remove overlaping sequences (redundancy) and generate final cleaned TE lib
awk 'BEGIN {i = 1;} { if ($1 ~ /^>/) { tmp = h[i]; h[i] = $1; } else if (!a[$1]) { s[i] = $1; a[$1] = "1"; i++; } else { h[i] = tmp; } } END { for (j = 1; j < i; j++) { print h[j]; print s[j]; } }' < combined-TE-lib.fa > final-TE-EDTA-RM.fa
## Now we have uniq and clean Transposon Element (TE) for the Alectoris rufa genome
## grep ">" combined-TE-lib.fa|wc -l == grep ">" final-TE-EDTA-RM.fa|wc -l == 4823 in total 
grep "^>" curated-EDTA.fa|wc -l
4452
grep "^>" uniq-RM-lib.fa|wc -l
371
grep "^>" final-TE-EDTA-RM.fa|wc -l
4823
## The use the RepeatMasker to perform softmasking on the Alectoris rufa genome
RepeatMasker -pa 15 -e ncbi -s -a -inv -dir SoftMask2 -no_is -norna -xsmall -nolow -div 40 -lib $lib -cutoff 225 $genomefile