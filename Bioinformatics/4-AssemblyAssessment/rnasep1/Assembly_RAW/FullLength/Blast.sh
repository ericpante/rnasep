#!/bin/bash
#SBATCH -p long
#SBATCH -J Trinity_Stats_rnasep1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 30:00:00
#SBATCH --error=Blastx_%j.err
#SBATCH --output=Blastx_%j.out

#Purge unused modules
module purge

#Load modules
module load blast/2.16.0

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/CountingFullLength/rnasep1/

blastx -query Trinity_rnasep1.Trinity95.fasta -db ../uniprot_sprot.fasta -out rnasep1.blastx95.outfmt6 -evalue 1e-20 -num_threads 20 -max_target_seqs 1 -outfmt 6
