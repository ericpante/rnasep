#!/bin/bash
#SBATCH -p long
#SBATCH -J gmapBuild
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=10G
#SBATCH -t 03:00:00
#SBATCH --error=Gbuild_%j.err
#SBATCH --output=Gbuild_%j.out

# Purge unused modules
module purge

# Load modules
module load gmap/2020.06.01

cd /shared/projects/rnasep/3a-AssemblyThinning/GenomeBased

GENOME=/shared/projects/rnasep/3a-AssemblyThinning/GenomeBased/mpibr_sepoff_v1.fa

gmap_build -D gmap_index -d sepoff_index ${GENOME}

