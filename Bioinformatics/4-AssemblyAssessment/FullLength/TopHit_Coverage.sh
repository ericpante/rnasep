#!/bin/bash
#SBATCH -p long
#SBATCH -J TopHitCoverage
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=10G
#SBATCH -t 01:00:00
#SBATCH --error=TopHit_%j.err
#SBATCH --output=Tophit_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/CountingFullLength/

analyze_blastPlus_topHit_coverage.pl blastx95.outfmt6 Trinity_rnasep2.Trinity95.fasta uniprot_sprot.fasta
