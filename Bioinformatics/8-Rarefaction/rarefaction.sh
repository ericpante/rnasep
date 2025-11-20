bP1_200M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 200000000 > eric_rarefaction_subP2_200M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 100000000 > eric_rarefaction_subP1_100M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 100000000 > eric_rarefaction_subP2_100M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 50000000  > eric_rarefaction_subP1_050M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 50000000  > eric_rarefaction_subP2_050M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 10000000  > eric_rarefaction_subP1_010M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 10000000  > eric_rarefaction_subP2_010M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 1000000   > eric_rarefaction_subP1_001M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 1000000   > eric_rarefaction_subP2_001M.fastq

# Index Trinity assembly
module load salmon/1.10.2  
salmon index -t Trinity_rnasep2.Trinity.fasta -i salmon_index_for_rarefaction

# Quantify on subsamples using paired reads
module load salmon/1.10.2  
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_allP1.fastq.gz    -2 eric_rarefaction_allP2.fastq.gz    -o reads_all/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_300M.fastq -2 eric_rarefaction_subP2_300M.fastq -o reads_sub_300M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_200M.fastq -2 eric_rarefaction_subP2_200M.fastq -o reads_sub_200M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_100M.fastq -2 eric_rarefaction_subP2_100M.fastq -o reads_sub_100M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_050M.fastq -2 eric_rarefaction_subP2_050M.fastq -o reads_sub_050M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_010M.fastq -2 eric_rarefaction_subP2_010M.fastq -o reads_sub_010M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_001M.fastq -2 eric_rarefaction_subP2_001M.fastq -o reads_sub_001M/salmon

# counting transcripts with ≥ 1 read
cd /shared/projects/rnasep/3-Assembling/rnasep2/Trinity_rnasep2/reads_all/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd /shared/projects/rnasep/3-Assembling/rnasep2/Trinity_rnasep2/reads_sub_300M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_200M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_100M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_050M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_010M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_001M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf

# cleaning up 
rm -fr eric_rarefaction_sub*.fastq.gz salmon_quant.out salmon_quant.err reads_*



####################### nexly hatched juveniles (rnasep1 project) #######################

# IFB settings
cd /shared/projects/rnasep/3-Assembling/rnasep1/Trinity_rnasep1

# pooling R1 and R2 reads
cat ../*R1_pe.fastq.gz > eric_rarefaction_allP1.fastq.gz
cat ../*R2_pe.fastq.gz > eric_rarefaction_allP2.fastq.gz

# counting total numbner of reads used in assembly
echo $(( $(zcat eric_rarefaction_allP1.fastq.gz | wc -l) / 4 )) # 87,985,565
echo $(( $(zcat eric_rarefaction_allP2.fastq.gz | wc -l) / 4 )) # 87,985,565


# subsampling the R1 and R2 fasta files that served as input for Trinity
module load seqtk/1.3
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 80000000 > eric_rarefaction_subP1_080M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 80000000 > eric_rarefaction_subP2_080M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 70000000 > eric_rarefaction_subP1_070M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 70000000 > eric_rarefaction_subP2_070M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 50000000 > eric_rarefaction_subP1_050M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 50000000 > eric_rarefaction_subP2_050M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 25000000 > eric_rarefaction_subP1_025M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 25000000 > eric_rarefaction_subP2_025M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 10000000 > eric_rarefaction_subP1_010M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 10000000 > eric_rarefaction_subP2_010M.fastq
seqtk sample -s100 eric_rarefaction_allP1.fastq.gz 1000000  > eric_rarefaction_subP1_001M.fastq
seqtk sample -s100 eric_rarefaction_allP2.fastq.gz 1000000  > eric_rarefaction_subP2_001M.fastq
 
# Index Trinity assembly
module load salmon/1.10.2  
salmon index -t ../Trinity_rnasep1.Trinity.fasta -i salmon_index_for_rarefaction

# Quantify on subsamples using paired reads
module load salmon/1.10.2  
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_allP1.fastq.gz    -2 eric_rarefaction_allP2.fastq.gz    -o reads_all/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_080M.fastq -2 eric_rarefaction_subP2_080M.fastq -o reads_sub_080M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_070M.fastq -2 eric_rarefaction_subP2_070M.fastq -o reads_sub_070M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_050M.fastq -2 eric_rarefaction_subP2_050M.fastq -o reads_sub_050M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_025M.fastq -2 eric_rarefaction_subP2_025M.fastq -o reads_sub_025M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_010M.fastq -2 eric_rarefaction_subP2_010M.fastq -o reads_sub_010M/salmon
salmon quant -i salmon_index_for_rarefaction -l A -1 eric_rarefaction_subP1_001M.fastq -2 eric_rarefaction_subP2_001M.fastq -o reads_sub_001M/salmon

# counting transcripts with ≥ 1 read
cd /shared/projects/rnasep/3-Assembling/rnasep1/Trinity_rnasep1/reads_all/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd /shared/projects/rnasep/3-Assembling/rnasep1/Trinity_rnasep1/reads_sub_080M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_070M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_050M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_025M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_010M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf
cd ../../reads_sub_001M/salmon/
awk 'NR>1 && $5 >= 1 {count++} END {print count}' quant.sf


