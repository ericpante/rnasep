#!/bin/bash
#SBATCH -p long
#SBATCH -J EggNOG.nt
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 20:00:00
#SBATCH --error=eggnog.nt_%j.err
#SBATCH --output=eggnog.nt_%j.out

#Purge unused modules
module purge

#Load modules
module load eggnog-mapper/2.1.11

cd /shared/projects/rnasep/5-AssemblyAnnotation/EggNOG/

export EGGNOG_DATA_DIR=/shared/projects/rnasep/5-AssemblyAnnotation/EggNOG/data/

#Defining variables
QUERY=Trinity_rnasep2.Trinity95.fasta.transdecoder.cds
OUTDIR=/shared/projects/rnasep/5-AssemblyAnnotation/EggNOG/outputNT
GFF=/shared/projects/rnasep/5-AssemblyAnnotation/EggNOG/Trinity_rnasep2.Trinity95.fasta.transdecoder.WB.gff3
#This is gff3 file from TransDecoder without empty lines

emapper.py -i ${QUERY} --itype CDS -m diamond --evalue 0.001 --tax_scope auto --target_orthologs all --go_evidence all --pfam_realign none --output_dir ${OUTDIR} -o rnasep2_Trinity95.nt --excel --decorate_gff ${GFF} --cpu 20 
