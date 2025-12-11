#!/bin/bash
#SBATCH -p long
#SBATCH -J EggNOG
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 20:00:00
#SBATCH --error=eggnog_%j.err
#SBATCH --output=eggnog_%j.out

#Purge unused modules
module purge

#Load modules
module load eggnog-mapper/2.1.11

cd /shared/projects/rnasep/5-AssemblyAnnotation/EggNOG/

export EGGNOG_DATA_DIR=/shared/projects/rnasep/5-AssemblyAnnotation/EggNOG/data/

#Defining variables
QUERY=Trinity95_rnasep2_longest_per_isoform.pep
OUTDIR=/shared/projects/rnasep/5-AssemblyAnnotation/EggNOG/output

emapper.py -i ${QUERY} -m diamond --evalue 0.001 --tax_scope 33213 --target_orthologs one2one --go_evidence all --output_dir ${OUTDIR} -o rnasep2_clean_Trinity95 --excel --cpu 20 
