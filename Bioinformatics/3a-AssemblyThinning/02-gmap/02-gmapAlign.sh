#!/bin/bash
#SBATCH -p long
#SBATCH -J gmapAlign
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=10G
#SBATCH -t 24:00:00
#SBATCH --error=Galign_%j.err
#SBATCH --output=Galign_%j.out

# Purge unused modules
module purge

# Load modules
module load gmap/2020.06.01

cd /shared/projects/rnasep/3a-AssemblyThinning/GenomeBased

ASSEMBLY=/shared/projects/rnasep/3a-AssemblyThinning/01-cd-hit/Trinity_rnasep2.Trinity95.fasta

gmapl -D gmap_index -d sepoff_index ${ASSEMBLY} --npaths 0 -t 16 --max-intronlength-ends 2000 --max-intronlength-middle 100000 -f gff3_match_cdna > Trinity_rnasep2.gmap.gff3
