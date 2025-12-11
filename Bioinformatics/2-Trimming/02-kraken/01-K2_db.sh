#!/bin/bash
#SBATCH -A rnasep
#SBATCH -p long
#SBATCH -J K2_db
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 10:00:00
#SBATCH --error=k2db_%j.err
#SBATCH --output=k2db_%j.out

# Purge unused modules
module purge

# Load modules
module load kraken2/2.14

cd /shared/projects/rnasep/2-Trimming/rnasep2/kraken

kraken2-build --download-taxonomy --db kraken2_bac_db
kraken2-build --download-library bacteria --db kraken2_bac_db
kraken2-build --download-library archaea --db kraken2_bac_db
kraken2-build --build --db kraken2_bac_db
kraken2-build --clean --db kraken2_bac_db
