#!/bin/bash
#SBATCH -p long
#SBATCH -J Hit2GO
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=20G
#SBATCH -t 10:00:00
#SBATCH --error=Hit2GOsep1_%j.err
#SBATCH --output=Hit2GOsep1_%j.out

zcat goa_uniprot_all.gaf.gz \
    | awk 'BEGIN{FS="\t"} !/^!/ {print $2"\t"$5}' \
    | grep -F -f <(awk '{split($2,a,"|"); print a[2]}' ../rnasep1/Trinity95_rnasep1_clean.outfmt6 | sort -u) \
	   > sep1_clean.swissprot_hit2go.tab

zcat goa_uniprot_all.gaf.gz \
    | awk 'BEGIN{FS="\t"} !/^!/ {print $2"\t"$5}' \
    | grep -F -f <(awk '{split($2,a,"|"); print a[2]}' ../rnasep1/Trinity95_rnasep1_clean_mollusca.outfmt6 | sort -u) \
	   > sep1_clean_mollusca.swissprot_hit2go.tab


