#!/bin/bash
#SBATCH -p long
#SBATCH -J BUSCO_rnasep1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
#SBATCH -t 20:00:00
#SBATCH --error=Blastx_%j.err
#SBATCH --output=Blastx_%j.out

#Purge unused modules
module purge

#Load modules
module load busco/5.5.0

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/Completeness/rnasep1

busco -i Trinity_rnasep1.Trinity95.fasta -m transcriptome -l mollusca_odb10 -c 20 -o BUSCO_rnasep1
