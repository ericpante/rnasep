#!/bin/bash
#SBATCH -p long
#SBATCH -J bowtieAlign
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=25G
#SBATCH -t 10:00:00
#SBATCH --error=Align_%j.err
#SBATCH --output=Align_%j.out
#SBATCH --array=1-18
#Purge unused modules
module purge

#Load modules
module load bowtie2/2.5.4
module load samtools/1.9

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/ReadContent/bowtie/rnasep1

ASSEMBLY=Trinity95_rnasep1_clean_min200.fasta

config=bowtie-config.txt

SAMPLE=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)

R1=${SAMPLE}_R1_pe.fastq.gz
R2=${SAMPLE}_R2_pe.fastq.gz



bowtie2 -p 20 -q --no-unal -k 20 -x ${ASSEMBLY} -1 ${R1} -2 ${R2} 2>${SAMPLE}.align_stats.txt | samtools view -@20 -b -o ${SAMPLE}.bam 
