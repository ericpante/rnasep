#!/bin/bash
#SBATCH -p long
#SBATCH -J BUSCO.rnasep1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
#SBATCH -t 20:00:00
#SBATCH --error=busco_%j.err
#SBATCH --output=busco_%j.out

#Purge unused modules
module purge

#Load modules
module load busco/5.5.0

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_RAW/Completeness/rnasep1

busco -i Trinity_rnasep1.Trinity.fasta -m transcriptome -l mollusca_odb10 -c 20 -o BUSCO_rnasep1
