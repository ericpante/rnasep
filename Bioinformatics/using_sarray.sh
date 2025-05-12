## Here is an exemple code snippet on know to use sarray on slurm

#!/bin/bash

#SBATCH --array=1-3%3       # Submit 3  tasks with task ID 1,2,3. max of 3 tasks
#SBATCH -p workq
#SBATCH -t 0-00:45  # days-hours:minutes"
#SBATCH -c 8

#Load modules
module load bioinfo/Cutadapt/4.3

# The name of the input files must reflect the task ID!
cutadapt --cores=8 -a AGATCGGAAGAGC -o 10639-JK-1_00${SLURM_ARRAY_TASK_ID}_S1_L005_R1_001_cutadapt.fastq.gz 10639-JK-1_${SLURM_ARRAY_TASK_ID}
_S1_L005_R1_001.fastq.gz

## my files are named like that : 
# 10639-JK-1_001_S1_L005_R1_001.fastq.gz
# 10639-JK-1_001_S1_L005_R2_001.fastq.gz
# 10639-JK-1_002_S1_L005_R1_001.fastq.gz
# 10639-JK-1_002_S1_L005_R2_001.fastq.gz
# 10639-JK-1_003_S1_L005_R1_001.fastq.gz
# 10639-JK-1_003_S1_L005_R2_001.fastq.gz
