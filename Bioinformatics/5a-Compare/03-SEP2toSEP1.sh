#!/bin/bash
#SBATCH -p long
#SBATCH -J 03-blast
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 10:00:00
#SBATCH --error=03-blast%j.err
#SBATCH --output=03-blast%j.out

module purge

module load diamond/2.1.9

diamond blastp -d SEP1.dmnd -q Trinity95_rnasep2_longest_per_isoform.pep -o SEP2vsSEP1.tsv --more-sensitive -e 1e-5 -k 1 --query-cover 0 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen
