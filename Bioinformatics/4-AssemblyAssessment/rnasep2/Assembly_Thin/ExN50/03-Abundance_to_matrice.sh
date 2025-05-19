#!/bin/bash
#SBATCH -p fast
#SBATCH -J Abundance_to_matrice95
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=20G
#SBATCH -t 03:00:00
#SBATCH --error=AbundanceToMatrice_%j.err
#SBATCH --output=AbundanceToMatrice_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/E90N50

#Defining variables
INDEX=rnasep2_Trinity95_Kallisto
OUTPUT=rnasep2_assembly95

abundance_estimates_to_matrix.pl --est_method kallisto --gene_trans_map Trinity_rnasep2.Trinity95.fasta.gene_trans_map --out_prefix rnasep2\
				 --name_sample_by_basedir\
				 Abundance_CT7.7_6/abundance.tsv\
				 Abundance_CT7.7_80/abundance.tsv\
				 Abundance_CT7.7_38/abundance.tsv\
				 Abundance_CT7.7_5/abundance.tsv\
				 Abundance_CT8.1_13/abundance.tsv\
				 Abundance_CT8.1_11/abundance.tsv\
				 Abundance_CT8.1_85/abundance.tsv\
				 Abundance_CT8.1_46/abundance.tsv\
				 Abundance_Hg7.7_24/abundance.tsv\
				 Abundance_Hg7.7_25/abundance.tsv\
				 Abundance_Hg7.7_20/abundance.tsv\
				 Abundance_Hg7.7_56/abundance.tsv\
				 Abundance_Hg8.1_28/abundance.tsv\
				 Abundance_Hg8.1_68/abundance.tsv\
				 Abundance_Hg8.1_30/abundance.tsv\
				 Abundance_Hg8.1_32/abundance.tsv
				 
