#!/bin/bash
#SBATCH -p workq
#SBATCH -J Trinity_test
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=50G
#SBATCH -t 60:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds". 

#Purge unused modules
module purge

#Load modules
#Need bowtie2, samtools, jellyfuish, salmon python
module load bioinfo/bowtie/2.5.1 bioinfo/samtools/1.14 bioinfo/Jellyfish/2.3.0 bioinfo/Salmon/1.10.0 devel/python/Python-3.11.1

module load bioinfo/trinityrnaseq/2.15.1

Trinity --seqType fq --max_memory 50G --samples_file config_file.txt --SS_lib_type FR --CPU 6 --output ~/work/rnasep/3-Assembling/Trinity_test
