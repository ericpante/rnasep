#!/bin/bash
#SBATCH -p long
#SBATCH -J bowtieIndex
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 10:00:00
#SBATCH --error=Index_%j.err
#SBATCH --output=Index_%j.out

#Purge unused modules
module purge

#Load modules
module load bowtie2/2.5.4

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/ReadContent/bowtie/rnasep1

bowtie2-build Trinity95_rnasep1_clean_min200.fasta Trinity95_rnasep1_clean_min200.fasta
