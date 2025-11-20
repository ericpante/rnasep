#!/bin/bash
#SBATCH -p long
#SBATCH -J Align-Final-rnasep2
#SBATCH --cpus-per-task=25
#SBATCH --mem-per-cpu=30G
#SBATCH -t 08:00:00
#SBATCH --error=align_%j.err
#SBATCH --output=align_%j.out
#SBATCH --array=1-12

#Purge unused modules
module purge

#Load modules
module load star/2.7.11a

cd /shared/projects/rnasep/6-Alignment/rnasep2/

#Defining variables
config=STAR-Config.txt
GENOME_DIR=/shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/ReadContent/Index
R1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
R2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$3}' $config)
OUT=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$4}' $config)

STAR --runThreadN 25 --genomeDir ${GENOME_DIR} --readFilesIn ${R1} ${R2} \
     --readFilesCommand gunzip -c --outSAMtype BAM Unsorted \
     --quantMode GeneCounts --outFileNamePrefix ${OUT}
