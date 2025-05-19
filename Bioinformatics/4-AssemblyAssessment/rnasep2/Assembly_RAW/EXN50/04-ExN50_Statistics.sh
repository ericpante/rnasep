#!/bin/bash
#SBATCH -p fast
#SBATCH -J ExN50_Statistics
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=20G
#SBATCH -t 03:00:00
#SBATCH --error=ExN50Stats95_%j.err
#SBATCH --output=ExN50Stats95_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/E90N50

#Defining variables
MATRIX=rnasep2.isoform.TMM.EXPR.matrix
ASSEMBLY=Trinity_rnasep2.Trinity.fasta
OUTPUT=rnasep2_ExN50.transcript.stats

contig_ExN50_statistic.pl ${MATRIX} ${ASSEMBLY} transcript | tee ${OUTPUT}

