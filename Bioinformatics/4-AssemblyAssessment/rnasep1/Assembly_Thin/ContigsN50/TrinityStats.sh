#!/bin/bash
#SBATCH -p long
#SBATCH -J Trinity_Stats_rnasep1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 05:00:00
#SBATCH --error=trinity_%j.err
#SBATCH --output=trinity_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/contigsNX/rnasep1

TrinityStats.pl Trinity_rnasep1.Trinity95.fasta
