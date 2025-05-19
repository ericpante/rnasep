#!/bin/bash
#SBATCH -p long
#SBATCH -J TransRate_rnasep1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 05:00:00
#SBATCH --error=TransRate_%j.err
#SBATCH --output=TransRate_%j.out

#Purge unused modules
module purge

#Load modules
module load transrate/1.0.3

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/stats/rnasep1

transrate --assembly Trinity_rnasep1.Trinity95.fasta --threads=10 --output /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/stats/rnasep1
