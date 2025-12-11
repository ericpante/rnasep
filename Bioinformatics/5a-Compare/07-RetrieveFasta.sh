
module load seqkit/2.9.0

# extraire RBH sequences from A and B
seqkit grep -f SEP1_RBH_ids.txt Trinity95_rnasep1_longest_per_isoform.pep -o rnasep1_RBH.pep
seqkit grep -f SEP2_RBH_ids.txt Trinity95_rnasep2_longest_per_isoform.pep -o rnasep2_RBH.pep

# extraire spécifiques noRBH
seqkit grep -f SEP1_specific_noRBH.txt Trinity95_rnasep1_longest_per_isoform.pep -o SEP1_specific.pep
seqkit grep -f SEP2_specific_noRBH.txt Trinity95_rnasep2_longest_per_isoform.pep -o SEP2_specific.pep

# extraire spécifiques nohit
seqkit grep -f SEP1_specific_nohit.txt Trinity95_rnasep1_longest_per_isoform.pep -o SEP1_specific_nohit.pep
seqkit grep -f SEP2_specific_nohit.txt Trinity95_rnasep2_longest_per_isoform.pep -o SEP2_specific_nohit.pep

module purge
