#!/bin/bash
#SBATCH -p workq
#SBATCH --time=04:00:00
#SBATCH	-J AfterTrimmingQC
#SBATCH -e error_out
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH	--mail-user=t.soldourdin@gmail.com
#SBATCH --mail-type=END

# Purge any previous module
module purge

# Load fastqc and multiqc environments
module load bioinfo/FastQC/0.12.1
module load bioinfo/MultiQC/1.14

cd ~/work/rnasep/1-QC

# perform FASTQC Quality Check on all fastq.gz files
fastqc -o /home/epante/work/rnasep/1-QC/ /home/epante/work/rnasep/2-Trimming/*pe.fastq.gz

# multiqc report
multiqc .
