awk 'FNR==NR{if($1~/^>/){id=$1;sub(/^>/,"",id);k[id]=1} next}
     /^>/{id=$1;sub(/^>/,"",id);p=id in k} p' \
     Trinity95_rnasep2_longest_per_isoform_originalIDs.pep Trinity95_rnasep2_clean_min200.fasta.transdecoder.cds > Trinity95_rnasep2_longest_per_isoform_originalIDs.cds
