#!/bin/bash
#SBATCH -p long
#SBATCH -J BUSCO
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
#SBATCH -t 20:00:00
#SBATCH --error=Blastx_%j.err
#SBATCH --output=Blastx_%j.out

#Purge unused modules
module purge

#Load modules
module load busco/5.5.0

cd /shared/projects/rnasep/3a-AssemblyAssessment/Completeness

busco -i Trinity_rnasep2.Trinity.fasta -m transcriptome -l mollusca_odb10 -c 20 -o BUSCO_rnasep2
