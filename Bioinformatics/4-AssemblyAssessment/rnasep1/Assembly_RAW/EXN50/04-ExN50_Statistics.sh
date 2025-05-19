#!/bin/bash
#SBATCH -p fast
#SBATCH -J ExN50_Statistics_rnasep1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=20G
#SBATCH -t 03:00:00
#SBATCH --error=ExN50Stats_%j.err
#SBATCH --output=ExN50Stats_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/3a-AssemblyAssessment/Assembly_RAW/rnasep1

#Defining variables
MATRIX=rnasep1.isoform.TMM.EXPR.matrix
ASSEMBLY=Trinity_rnasep1.Trinity.fasta
OUTPUT=rnasep1_ExN50.transcript.stats

contig_ExN50_statistic.pl ${MATRIX} ${ASSEMBLY} transcript | tee ${OUTPUT}

