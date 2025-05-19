#!/bin/bash
#SBATCH -p fast
#SBATCH -J Quant_Array
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=20G
#SBATCH -t 03:00:00
#SBATCH --error=Quant_Array%j.err
#SBATCH --output=Quant_Array%j.out
#SBATCH --array=1-16

#Purge unused modules
module purge

#Load modules
module load kallisto/0.46.2

#Defining variables
config=Kallisto-Config.txt
INDEX=rnasep2_Trinity95_Kallisto
READ1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
READ2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$3}' $config)
OUTPUT=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$4}' $config)


cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/ExN50/



kallisto quant -i ${INDEX} -o Abundance_${OUTPUT} ${READ1} ${READ2}
