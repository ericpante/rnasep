#!/bin/bash
#SBATCH -p long
#SBATCH --job-name=TrimArrayJob
#SBATCH -t 02:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
#SBATCH --mem=40G
#SBATCH --cpus-per-task=6
#SBATCH --array=1-36

module purge

#Load modules
module load trimmomatic/0.39

cd /shared/projects/rnaseq/2-Trimming/.
config=Trimmomatic-Config.txt
READ1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
READ2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$3}' $config)
OUTPUT=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$4}' $config)
SRC=/shared/ifbstor1/software/miniconda/envs/trimmomatic-0.39/share/trimmomatic-0.39-1

trimmomatic PE -threads 4 -phred33 ${READ1} ${READ2} ${OUTPUT}_R1_pe.fastq.gz ${OUTPUT}_R1_se.fastq.gz ${OUTPUT}_R2_pe.fastq.gz ${OUTPUT}_R2_se.fastq.gz ILLUMINACLIP:${SRC}/adapters/TruSeq3-PE.fa:2:30:10 LEADING:20 TRAILING:20 HEADCROP:10 SLIDINGWINDOW:4:20 MINLEN:100
