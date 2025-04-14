#!/bin/bash
#SBATCH -p long
#SBATCH -J TransDecoder_ORF_rnasep1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 30:00:00
#SBATCH --error=ORF_%j.err
#SBATCH --output=ORF_%j.out

#Purge unused modules
module purge

#Load modules
module load transdecoder/5.7.0

cd /shared/projects/rnasep/5-AssemblyAnnotation/TransDecoder/Assembly_Thin/rnasep1

TransDecoder.LongOrfs -t Trinity_rnasep1.Trinity95.fasta
