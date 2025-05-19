#!/bin/bash
#SBATCH -p long
#SBATCH -J TopHitCoverage_rnasep1
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=10G
#SBATCH -t 01:00:00
#SBATCH --error=TopHit_%j.err
#SBATCH --output=Tophit_%j.out

#Purge unused modules
module purge

#Load modules
module load trinity/2.15.1

cd /shared/projects/rnasep/4-AssemblyAssessment/Assembly_Thin/CountingFullLength/rnasep1/

analyze_blastPlus_topHit_coverage.pl rnasep1.blastx95.outfmt6 Trinity_rnasep1.Trinity95.fasta ../uniprot_sprot.fasta
