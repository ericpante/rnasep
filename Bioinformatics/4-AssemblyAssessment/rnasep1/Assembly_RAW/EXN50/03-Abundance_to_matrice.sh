#!/bin/bash
#SBATCH -p fast
#SBATCH -J Abundance_to_matrice_rnasep1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=20G
#SBATCH -t 03:00:00
#SBATCH --error=AbundanceToMatrice_%j.err
#SBATCH --output=AbundanceToMatrice_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/3a-AssemblyAssessment/Assembly_RAW/rnasep1

#Defining variables
INDEX=rnasep1_Trinity_Kallisto
OUTPUT=rnasep1_assembly

abundance_estimates_to_matrix.pl --est_method kallisto --gene_trans_map Trinity_rnasep1.Trinity.fasta.gene_trans_map --out_prefix rnasep1\
				 --name_sample_by_basedir\
				 Abundance_CT7.7_15/abundance.tsv\
				 Abundance_CT7.7_2/abundance.tsv\
				 Abundance_CT7.7_93/abundance.tsv\
				 Abundance_CT8.1_9/abundance.tsv\
				 Abundance_CT8.1_82/abundance.tsv\
				 Abundance_CT8.1_3/abundance.tsv\
				 Abundance_Hg7.7_125/abundance.tsv\
				 Abundance_Hg7.7_2/abundance.tsv\
				 Abundance_Hg7.7_52/abundance.tsv\
				 Abundance_Hg8.1_36/abundance.tsv\
				 Abundance_Hg8.1_111/abundance.tsv\
				 Abundance_Hg8.1_6/abundance.tsv\
				 Abundance_Ag7.7_1/abundance.tsv\
				 Abundance_Ag7.7_2/abundance.tsv\
				 Abundance_Ag7.7_34/abundance.tsv\
				 Abundance_Ag8.1_2/abundance.tsv\
				 Abundance_Ag8.1_102/abundance.tsv\
				 Abundance_Ag8.1_27/abundance.tsv
				 
