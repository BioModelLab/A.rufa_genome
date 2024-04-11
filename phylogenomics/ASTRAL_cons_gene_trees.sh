#!/bin/bash

# Add miniconda3 to PATH
#. /home/abdul/anaconda3/etc/profile.d/conda.sh
. /home/abdul/mambaforge/etc/profile.d/conda.sh

# This script
# condatenate all buscos single copy into one supergene


genetreefile=ALL.tree
ASTRAL=Astral/astral.5.7.3.jar
consensustree_output=ALL_SUPERTREE_sp_original.nex


java -jar $ASTRAL -i $genetreefile -o $consensustree_output
