#!/bin/bash
#SBATCH -p long
#SBATCH -J Trinity_test_6_Ech
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=50G
#SBATCH -t 15:00:00
#SBATCH --error=trinity_%j.err
#SBATCH --output=trinity_%j.out

#Purge unused modules
module purge

#Load modules
#Need bowtie2, samtools, jellyfish, salmon & python which are expected to be packed with Trinity via Conda:
#https://community.france-bioinformatique.fr/t/erreur-de-module-lie-a-lutilisation-de-trinity/3972/10
module load trinity/2.15.1
module load salmon/1.10.2

cd /shared/projects/rnasep/3-Assembling/

#Defining variables
SAMPLE=Trinity-Config-Test.txt
OUTPUT=Trinity_test

Trinity --seqType fq --max_memory 50G --samples_file ${SAMPLE} --SS_lib_type FR --CPU 16 --output ${OUTPUT}
