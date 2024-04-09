#!/bin/bash
agp="$1"
awk 'BEGIN{OFS=FS="\t"}$9=="?"{$9="+"}{print}' ${agp} |\
sed '/^scaf_/s/^scaf_/scaffold_/g' |\
sed '/^scaf-alt/s/^scaf-alt/scaffold-alt/g' |\
awk 'BEGIN{OFS=FS="\t"}$7=="map"{$7="scaffold"}{print}' |\
sed 's/\tyes\t/\tyes\tmap/g'
