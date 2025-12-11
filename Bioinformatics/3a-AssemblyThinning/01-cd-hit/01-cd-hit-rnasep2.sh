#!/bin/bash
#SBATCH -p long
#SBATCH -J CD-HIT
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=16G
#SBATCH -t 05:00:00
#SBATCH --error=CD-HIT_%j.err
#SBATCH --output=CD-HIT__%j.out

#Purge unused modules
module purge

#Load modules
module load cd-hit/4.8.1

cd /shared/projects/rnasep/3a-AssemblyThinning/

cd-hit-est -i Trinity_rnasep2.Trinity.fasta -o Trinity_rnasep.Trinity95.fasta -c 0.95 -n 10 -d 0 -M 16000
