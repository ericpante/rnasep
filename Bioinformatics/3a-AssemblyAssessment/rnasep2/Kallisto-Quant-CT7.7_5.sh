#!/bin/bash
#SBATCH -p fast
#SBATCH -J Quant_CT7.7_5
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=20G
#SBATCH -t 03:00:00
#SBATCH --error=Quant_7.7_5_%j.err
#SBATCH --output=Quant_7.7_5_%j.out

#Purge unused modules
module purge

#Load modules
module load kallisto/0.46.2

cd /shared/projects/rnasep/3a-AssemblyAssessment/

#Defining variables
INDEX=rnasep2_Trinity_Kallisto
OUTPUT=Abundance_CT7.7_5

kallisto quant -i ${INDEX} -o ${OUTPUT} SEP2-CT7.7_5_R1_pe.fastq.gz SEP2-CT7.7_5_R2_pe.fastq.gz
