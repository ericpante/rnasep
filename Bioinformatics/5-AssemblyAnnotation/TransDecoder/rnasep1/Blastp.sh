#!/bin/bash
#SBATCH -p long
#SBATCH -J BlastP_ORF_rnasep1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 20:00:00
#SBATCH --error=Blastp_%j.err
#SBATCH --output=Blastp_%j.out

#Purge unused modules
module purge

#Load modules
module load blast/2.16.0

cd /shared/projects/rnasep/5-AssemblyAnnotation/TransDecoder/Assembly_Thin/rnasep1/

#Defining variable
DATABASE=/shared/projects/rnasep/5-AssemblyAnnotation/Blast/uniprot_sprot.fasta

blastp -query Trinity_rnasep1.Trinity95.fasta.transdecoder_dir/longest_orfs.pep -db ${DATABASE} -out rnasep1_TransDecoder_blastp.outfmt6 -evalue 1e-5 -num_threads 20 -max_target_seqs 1 -outfmt 6
