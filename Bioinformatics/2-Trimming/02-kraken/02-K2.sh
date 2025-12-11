#!/bin/bash
#SBATCH -A rnasep
#SBATCH -p long
#SBATCH -J K2
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 15:00:00
#SBATCH --error=k2_%j.err
#SBATCH --output=k2_%j.out
#SBATCH --array=1-18

# Purge unused modules
module purge

# Load modules
module load kraken2/2.14

cd /shared/projects/rnasep/2-Trimming/rnasep1/kraken

config=kraken-config.txt
R1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$2}' $config)
R2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$3}' $config)
OUTPUT=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$4}' $config)
REPORT=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print$5}' $config)

kraken2 --threads 20 --quick  --paired --db kraken2_bac_db --unclassified-out ${OUTPUT} ${R1} ${R2} --report ${REPORT}

