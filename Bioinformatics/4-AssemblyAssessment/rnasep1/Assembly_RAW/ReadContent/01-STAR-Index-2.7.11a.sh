#!/bin/bash
#SBATCH -p long
#SBATCH -J Index-Assembly-rnasep1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=30G
#SBATCH -t 05:00:00
#SBATCH --error=index_%j.err
#SBATCH --output=index_%j.out

#Purge unused modules
module purge

#Load modules
module load star/2.7.11a

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_RAW/ReadContent/rnasep1

#Defining variables
ASSEMBLY=Trinity_rnasep1.Trinity.fasta
GENOME_DIR=/shared/projects/rnasep/4-AssemblyAssessment/Assembly_RAW/ReadContent/rnasep1/Index
GTF=Trinity_rnasep1.Trinity.fasta.transdecoder.gtf
STAR --runThreadN 10 --genomeSAindexNbases 12 --limitGenomeGenerateRAM 338130108682 --runMode genomeGenerate --genomeDir ${GENOME_DIR} --genomeFastaFiles ${ASSEMBLY} --sjdbGTFfile ${GTF} --sjdbOverhang 149
