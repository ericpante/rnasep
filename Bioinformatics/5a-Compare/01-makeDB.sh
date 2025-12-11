#!/bin/bash
#SBATCH -p long
#SBATCH -J makeDB
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 10:00:00
#SBATCH --error=makeDB%j.err
#SBATCH --output=makeDB%j.out

module purge

module load diamond/2.1.9

diamond makedb --in Trinity95_rnasep1_longest_per_isoform.pep -d SEP1.dmnd
diamond makedb --in Trinity95_rnasep2_longest_per_isoform.pep -d SEP2.dmnd
