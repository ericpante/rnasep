#!/bin/bash
#SBATCH -p long
#SBATCH -J Trinity_Stats
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 05:00:00
#SBATCH --error=trinity_%j.err
#SBATCH --output=trinity_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/contigsNX

TrinityStats.pl Trinity_rnasep2.Trinity95.fasta
