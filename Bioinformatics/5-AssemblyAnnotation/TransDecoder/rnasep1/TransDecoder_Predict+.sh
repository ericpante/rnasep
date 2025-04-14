#!/bin/bash
#SBATCH -p long
#SBATCH -J TransDecoder_Predict+_rnasep1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 10:00:00
#SBATCH --error=Predict+_%j.err
#SBATCH --output=Predict+_%j.out

#Purge unused modules
module purge

#Load modules
module load transdecoder/5.7.0

cd /shared/projects/rnasep/5-AssemblyAnnotation/TransDecoder/Assembly_Thin/rnasep1

TransDecoder.Predict -t Trinity_rnasep1.Trinity95.fasta --retain_blastp_hits rnasep1_TransDecoder_blastp.outfmt6
