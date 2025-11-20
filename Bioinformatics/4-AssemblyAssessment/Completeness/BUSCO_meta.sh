#!/bin/bash
#SBATCH -p long
#SBATCH -J BUSCO_meta
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 01:00:00
#SBATCH --error=busco_meta_%j.err
#SBATCH --output=busco_meta_%j.out

#Purge unused modules
module purge

#Load modules
module load busco/5.5.0

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/Completeness

busco -i Trinity_rnasep2.Trinity95.fasta -m transcriptome -l metazoa_odb10 -c 20 -o BUSCOmeta_rnasep2
