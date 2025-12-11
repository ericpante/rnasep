# réduire aux mapping q -> s
cut -f1,2 SEP1vsSEP2.filtered.tsv | sort > SEP1vsSEP2_sorted.tsv
cut -f1,2 SEP2vsSEP1.filtered.tsv | sort > SEP2vsSEP1_sorted.tsv

# on inverse B2A pour avoir s -> q (soit subject in B is query in B->A)
# B_vs_A has q=B_s, s=A_x so B2A_sorted is q(B)->s(A)
# we want to check for each A->B pair if B->A maps back to the same A

# We'll use awk to detect reciprocals:
awk 'NR==FNR{a[$1"\t"$2]=1; next} { if (a[$2"\t"$1]) print $1"\t"$2 }' SEP2vsSEP1_sorted.tsv SEP1vsSEP2_sorted.tsv > RBH_pairs.tsv
