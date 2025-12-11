#!/bin/bash
#SBATCH -p long
#SBATCH -J Longest_ORF_per_isoform
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
#SBATCH -t 02:00:00
#SBATCH --error=longest_orf_%j.err
#SBATCH --output=longest_orf_%j.out

module purge
module load seqkit/2.9.0

# Variables
PEP_FILE="Trinity95_rnasep2_clean_min200.fasta.transdecoder.pep"
CLEAN_PEP="SEP2_clean.pep"
OUT_REDUCED="Trinity95_rnasep2_longest_per_isoform.pep"
OUT_ORIG="Trinity95_rnasep2_longest_per_isoform_originalIDs.pep"

# 0) Nettoyer les IDs pour séquences intermédiaires
awk '/^>/{split($0,a," "); print a[1]; next} {print}' ${PEP_FILE} > ${CLEAN_PEP}

# 1) Générer tableau id -> longueur
seqkit fx2tab -n -l ${CLEAN_PEP} > ids_len.tsv
# ids_len.tsv : <full_id>\t<length>

# 2) Extraire l'ID de l'isoforme (TRINITY_DN0_c0_g1_i3.p1)
awk -F'\t' '{
  isoform=$1
  sub(/\.p[0-9]+$/,"",isoform)
  print isoform"\t"$1"\t"$2
}' ids_len.tsv > isoform_id_len.tsv
# Format: <isoforme>\t<ID complet>\t<longueur>

# 3) Pour chaque isoforme, garder le plus long ORF
sort -k1,1 -k3nr isoform_id_len.tsv | awk -F'\t' '!seen[$1]++ {print $2}' > longest_ids.txt

# 4a) Extraire les séquences avec IDs réduits
seqkit grep -f longest_ids.txt ${CLEAN_PEP} -o ${OUT_REDUCED}

# 4b) Extraire les séquences avec IDs originaux
seqkit grep -f longest_ids.txt ${PEP_FILE} -o ${OUT_ORIG}

echo "Extraction terminée :"
echo " - IDs réduits : ${OUT_REDUCED}"
echo " - IDs originaux : ${OUT_ORIG}"
