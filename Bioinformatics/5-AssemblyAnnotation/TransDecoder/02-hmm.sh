#!/bin/bash
#SBATCH -p long
#SBATCH -J PFAM_ORF
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 20:00:00
#SBATCH --error=hmm_%j.err
#SBATCH --output=hmm_%j.out

#Purge unused modules
module purge

#Load modules
module load hmmer/3.3.2

cd /shared/projects/rnasep/5-AssemblyAnnotation/TransDecoder/Assembly_Thin/

#Defining variable
DATABASE=/shared/bank/PFAM/Pfam-A.hmm

hmmscan --cpu 20 --domtblout rnasep2.pfam.domtblout ${DATABASE} Trinity95_rnasep2_clean_min200.fasta.transdecoder_dir/longest_orfs.pep
