# paramètres
MIN_PID=30
MIN_COV=0.5

# filtre SEP1->SEP2
awk -v pid=$MIN_PID -v cov=$MIN_COV '{
  qlen=$13; aln=$4;
  if (qlen>0 && ($3 >= pid) && (aln/qlen >= cov)) print
}' SEP1vsSEP2.tsv > SEP1vsSEP2.filtered.tsv

# filtre SEP2->SEP1
awk -v pid=$MIN_PID -v cov=$MIN_COV '{
  qlen=$13; aln=$4;
  if (qlen>0 && ($3 >= pid) && (aln/qlen >= cov)) print
}' SEP2vsSEP1.tsv > SEP2vsSEP1.filtered.tsv
