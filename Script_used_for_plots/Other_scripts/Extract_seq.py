#!/usr/bin/env python3
# -*- coding: utf-8 -*-


from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import sys



ids_file = sys.argv[1]
input_fasta = sys.argv[2]
output_fasta = sys.argv[3]
my_records = []
ids_lst = []

with open(ids_file) as ids:
    ids = ids.readlines()
    for id1 in ids:
        id1 = id1.strip()
        ids_lst.append(id1)


for seq_record in SeqIO.parse(input_fasta, "fasta"):
    if seq_record.id in ids_lst:
        rec = SeqRecord(seq_record.seq, id=seq_record.id, description=seq_record.description)
        my_records.append(rec)

SeqIO.write(my_records, output_fasta, 'fasta')