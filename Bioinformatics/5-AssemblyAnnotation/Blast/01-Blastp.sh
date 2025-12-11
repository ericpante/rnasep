#!/bin/bash
#SBATCH -p long
#SBATCH -J Trinity_Stats
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 30:00:00
#SBATCH --error=Blastx_%j.err
#SBATCH --output=Blastx_%j.out

#Purge unused modules
module purge

#Load modules
module load blast/2.16.0

cd /shared/projects/rnasep/5-AssemblyAnnotation/Blast/

blastp -query Trinity95_rnasep2_longest_per_isoform.pep -db uniprot_sprot.fasta -out Trinity95_rnasep2_clean_.outfmt6 -evalue 1e-5 -num_threads 20 -max_target_seqs 1 -outfmt 6
