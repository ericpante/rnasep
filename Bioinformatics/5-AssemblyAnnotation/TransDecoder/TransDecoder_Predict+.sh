#!/bin/bash
#SBATCH -p long
#SBATCH -J TransDecoder_Predict+
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=50G
#SBATCH -t 30:00:00
#SBATCH --error=Predict+_%j.err
#SBATCH --output=Predict+_%j.out

#Purge unused modules
module purge

#Load modules
module loadtransdecoder/5.7.0

cd /shared/projects/rnasep/5-AssemblyAnnotation/TransDecoder/Assembly_Thin/

TransDecoder.Predict -t Trinity_rnasep2.Trinity95.fasta --retain_blastp_hits rnasep2_TransDecoder_blastp.outfmt6
