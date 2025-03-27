#!/bin/bash
#SBATCH -p long
#SBATCH -J TransDecoder_Predict
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=50G
#SBATCH -t 30:00:00
#SBATCH --error=Predict_%j.err
#SBATCH --output=Predict_%j.out

#Purge unused modules
module purge

#Load modules
module loadtransdecoder/5.7.0

cd /shared/projects/rnasep/3b-AssemblyAnnotation

TransDecoder.Predict -t Trinity_rnasep2.Trinity.fasta
