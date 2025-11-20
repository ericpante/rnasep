#!/bin/bash
#SBATCH -p long
#SBATCH -J Index-Assembly95-rnasep2
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=30G
#SBATCH -t 05:00:00
#SBATCH --error=index_%j.err
#SBATCH --output=index_%j.out

#Purge unused modules
module purge

#Load modules
module load star/2.7.11a

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/ReadContent/

#Defining variables
ASSEMBLY=Trinity_rnasep2.Trinity95.fasta
GENOME_DIR=/shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/ReadContent/Index
GTF=Trinity_rnasep2.Trinity95.fasta.transdecoder.gtf
STAR --runThreadN 10 --genomeSAindexNbases 12 --limitGenomeGenerateRAM 338130108682 --runMode genomeGenerate --genomeDir ${GENOME_DIR} --genomeFastaFiles ${ASSEMBLY} --sjdbGTFfile ${GTF} --sjdbOverhang 149
