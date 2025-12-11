#!/bin/bash
#SBATCH -p long
#SBATCH -J makeDB
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 10:00:00
#SBATCH --error=makeDB%j.err
#SBATCH --output=makeDB%j.out

module purge

module load diamond/2.1.9

diamond blastp -d SEP2.dmnd -q Trinity95_rnasep1_longest_per_isoform.pep -o SEP1vsSEP2.tsv --more-sensitive -e 1e-5 -k 1 --query-cover 0 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen
