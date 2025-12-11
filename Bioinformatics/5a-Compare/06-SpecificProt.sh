# tous les queries A
grep -v "^#" Trinity95_rnasep1_longest_per_isoform.pep | grep ">" -n >/dev/null

module load seqkit/2.9.0

# get list of all A ids (FASTA headers without '>')
# use seqkit (recommended) or awk
seqkit seq -n Trinity95_rnasep1_longest_per_isoform.pep > SEP1_all_ids.txt
seqkit seq -n Trinity95_rnasep2_longest_per_isoform.pep > SEP2_all_ids.txt

# Clean IDs
awk '{print $1}' SEP1_all_ids.txt | sort > SEP1_all_ids_clean.txt
awk '{print $1}' SEP2_all_ids.txt | sort > SEP2_all_ids_clean.txt

# list of A that have a filtered hit (any)
cut -f1 SEP1vsSEP2.filtered.tsv | sort | uniq > SEP1_with_hits.txt
cut -f1 SEP2vsSEP1.filtered.tsv | sort | uniq > SEP2_with_hits.txt

# RBH A ids
cut -f1 RBH_pairs.tsv | sort | uniq > SEP1_RBH_ids.txt
cut -f2 RBH_pairs.tsv | sort | uniq > SEP2_RBH_ids.txt

# A specific: those in A_all_ids but not in A_with_hits (no hit) OR not in RBH (no reciprocal)
# option 1: specific = no hit
comm -23 <(sort SEP1_all_ids_clean.txt) <(sort SEP1_with_hits.txt) > SEP1_specific_nohit.txt
comm -23 <(sort SEP2_all_ids_clean.txt) <(sort SEP2_with_hits.txt) > SEP2_specific_nohit.txt

# option 2: specific = not in RBH
comm -23 <(sort SEP1_all_ids_clean.txt) <(sort SEP1_RBH_ids.txt) > SEP1_specific_noRBH.txt
comm -23 <(sort SEP2_all_ids_clean.txt) <(sort SEP2_RBH_ids.txt) > SEP2_specific_noRBH.txt
