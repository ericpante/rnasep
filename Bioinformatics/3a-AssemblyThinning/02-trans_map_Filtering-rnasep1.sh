#!/bin/bash
#SBATCH -p fast
#SBATCH -J filtering
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=10G
#SBATCH --time=01:00:00
#SBATCH --output=filter_%j.out

cd /shared/projects/rnasep/3a-AssemblyThinning/rnasep1/

FASTA=Trinity_rnasep1.Trinity95.fasta
TRANS_MAP=Trinity_rnasep1.Trinity.fasta.gene_trans_map

#Checking files
if [ ! -f "$TRANS_MAP" ] || [ ! -f "$FASTA"$]; then
    echo "One file is missing."
    exit 1
fi

#Extracting sequences identifiers from the FASTA file:
grep "^>" "$FASTA" | sed 's/^>//' | cut -d' ' -f1 > motifs_fasta_tmp.txt

#Filtering trans_map file in order to keep only lines with identifiers from the FASTA file
awk 'NR==FNR {motifs[$1]; next} $2 in motifs' motifs_fasta_tmp.txt "$TRANS_MAP" > Trinity_rnasep1.Trinity95.fasta.gene_trans_map

#Delete temp file:
rm motifs_fasta_tmp.txt
