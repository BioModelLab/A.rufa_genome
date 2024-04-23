#!/usr/bin/env python3
#This is a  Modified  version of the original code  form https://github.com/pedronachtigall/CodAn/blob/master/scripts/RemoveRedundancy.py 
#by Pedro G. Nachtigall (pedronachtigall@gmail.com)

#!/usr/bin/env python3
import sys
from Bio import SeqIO
from Bio.Align import PairwiseAligner
from Bio.Align.fasta import AlignmentWriter

def parse_fasta_records(fasta):
    records = {}
    for record in SeqIO.parse(fasta, "fasta"):
        records[record.id] = str(record.seq)
    return records

def remove_redundancy(fasta, output, report, identity_threshold):
    fasta_records = parse_fasta_records(fasta)
    aligner = PairwiseAligner()
    aligner.mode = 'global'
    aligner.match_score = 1
    aligner.mismatch_score = 0
    aligner.open_gap_score = -1
    aligner.extend_gap_score = -0.5
    clusters = {}
    cluster_count = 0
    for id1, seq1 in fasta_records.items():
        added = False
        for cluster_id, cluster_seqs in clusters.items():
            for id2, seq2 in cluster_seqs.items():
                alignments = aligner.align(seq1, seq2)
                alignment = alignments[0]
                alignment_length = max(len(alignment[0]), len(alignment[1]))
                identity = alignment.score / alignment_length * 100
                if identity >= identity_threshold:
                    clusters[cluster_id][id1] = seq1
                    added = True
                    break
            if added:
                break
        if not added:
            clusters[cluster_count] = {id1: seq1}
            cluster_count += 1
    with open(output, "w") as out_file:
        with open(report, "w") as report_file:
            writer = AlignmentWriter(out_file)
            for cluster_id, cluster_seqs in clusters.items():
                report_file.write("//Cluster_" + str(cluster_id) + "\n")
                for id, seq in cluster_seqs.items():
                    writer.write_header(id)
                    writer.write_alignment(seq)
                    report_file.write("\t" + id + "\n")

def main():
    if len(sys.argv) != 5:
        print("Usage: RemoveRedundancy.py input.fa output.fa report.txt identity_threshold")
        print("\t> input.fa: input file in fasta format")
        print("\t> output.fa: output sequences with break lines in fasta format [100 nts per line]")
        print("\t> report.txt: report file")
        print("\t> identity_threshold: percentage of identity for clustering sequences (e.g., 90, 80, 100)")
        sys.exit(1)

    fasta_file = sys.argv[1]
    output_file = sys.argv[2]
    report_file = sys.argv[3]
    identity_threshold = float(sys.argv[4])

    remove_redundancy(fasta_file, output_file, report_file, identity_threshold)

if __name__ == "__main__":
    main()
