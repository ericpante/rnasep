#!/bin/bash
#SBATCH -p long
#SBATCH --job-name=fastpArrayTest
#SBATCH -t 05:00:00 #Acceptable time formats include "minutes", "minutes:seconds", "hours:minutes:seconds", "days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".
#SBATCH --mem=50G
#SBATCH --cpus-per-task=15
#SBATCH --array=1-36

module purge

#Load modules
module load fastp/0.23.1

cd /shared/projects/rnaseq/2-Trimming/fastp/.
config=Fastp-Config.txt
READ1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
READ2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$3}' $config)
OUTPUT=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$4}' $config)


fastp --thread 15 -i ${READ1} -o ${OUTPUT}_R1_pe.fastq.gz -I ${READ2} -O ${OUTPUT}_R2_pe.fastq.gz --qualified_quality_phred 30 --unqualified_percent_limit 10 --detect_adapter_for_pe --adapter_fasta Adapters.fa --length_required 135
