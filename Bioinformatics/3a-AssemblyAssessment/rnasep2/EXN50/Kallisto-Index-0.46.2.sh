#!/bin/bash
#SBATCH -p fast
#SBATCH -J Kallisto-Index-rnasep2
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 00:30:00
#SBATCH --error=Kallisto-Index_%j.err
#SBATCH --output=Kallisto-Index_%j.out

#Purge unused modules
module purge

#Load modules
module load kallisto/0.46.2

cd /shared/projects/rnasep/3a-AssemblyAssessment/

#Defining variables
ASSEMBLY=Trinity_rnasep2.Trinity.fasta
BASE=rnasep2_Trinity_Kallisto

kallisto index -i ${BASE} ${ASSEMBLY}
