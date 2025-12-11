#!/bin/bash
#SBATCH -p long
#SBATCH -J GFF2Clean
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=50G
#SBATCH -t 30:00:00
#SBATCH --error=GFF2Clean_%j.err
#SBATCH --output=GFF2Clean_%j.out


#########
# Loading modules
#########

module purge

module load seqkit/2.9.0

###############################################################################
# CONFIGURATION
###############################################################################

GFF="Trinity_rnasep2.gmap.gff3"
FASTA="../01-cd-hit/Trinity_rnasep2.Trinity95.fasta"

MAX_INTRON=200000

###############################################################################
# 1) Detect all chimeras
###############################################################################

echo "Detecting chimeras ..."

awk -v max_intron=$MAX_INTRON '
BEGIN {
}
$3=="cDNA_match" {
    # Extract transcript ID
    split($9,a,";");
    for(i in a){
        if(a[i] ~ /^ID=/){
            id = substr(a[i],4);
        }
    }

    chr[id]    = (id in chr    ? chr[id]    OR FS $1 : $1)
    strand[id] = (id in strand ? strand[id] OR FS $7 : $7)

    # store segments
    starts[id, ++n[id]]  = $4
    ends[id,   n[id]]    = $5
    chrom[id,  n[id]]    = $1
    str[id,    n[id]]    = $7
}
END {
    for(t in chr){

        ###############################
        # 1) multichromosomal chimeras
        ###############################
        split(chr[t],ch," ")
        uniq_chr=""
        delete seen

        for(i in ch){
            if(!seen[ch[i]]++){
                uniq_chr = uniq_chr " " ch[i]
            }
        }
        split(uniq_chr,chr_list," ")
        if(length(chr_list)>2){
            print t
            continue
        }

        ###########################
        # 2) contradictory strands
        ###########################
        split(strand[t],st," ")
        uniq_st=""
        delete seen_st

        for(i in st){
            if(!seen_st[st[i]]++){
                uniq_st = uniq_st " " st[i]
            }
        }
        split(uniq_st,st_list," ")
        if(length(st_list)>2){
            print t
            continue
        }

        ###########################
        # 3) internal structure check
        ###########################
        # sort segments
        for(i=1;i<=n[t];i++){
            idx[i]=i
        }
        for(i=1;i<=n[t];i++){
            for(j=i+1;j<=n[t];j++){
                if(starts[t,idx[j]] < starts[t,idx[i]]){
                    tmp=idx[i]; idx[i]=idx[j]; idx[j]=tmp
                }
            }
        }

        prev_end = -1
        inv = 0
        gap = 0

        for(i=1;i<=n[t];i++){
            si = idx[i]

            # internal inversion
            if(i>1 && starts[t,si] < prev_end){
                inv = 1
            }

            # too large internal gap
            if(i>1 && starts[t,si] - prev_end > max_intron){
                gap = 1
            }

            prev_end = ends[t,si]
        }

        if(inv==1 || gap==1){
            print t
            continue
        }
    }
}' $GFF > chimera_full_detection.txt

# Clean IDs
awk '{
    id = $1;
    sub(/\.path[0-9]+$/, "", id);
    print id "\t" $2;
}' chimera_full_detection.txt \
  | sort -k1,1 \
  > chimera_ids_clean.txt

###############################################################################
# 2) Detect too short or poorly aligned transcripts
###############################################################################

echo "Computing alignment lengths ..."

awk '
$3=="cDNA_match" {
    split($9,a,";");
    for(i in a){
        if(a[i] ~ /^ID=/){
            id = substr(a[i],4);
        }
    }
    len = $5 - $4 + 1
    aligned[id] += len
}
END {
    for(t in aligned){
        print t "\t" aligned[t]
    }
}' $GFF > aligned_lengths.txt

# Clean IDs
awk '{
    id=$1;
    sub(/\.path[0-9]+$/, "", id);
    print id "\t" $2
}' aligned_lengths.txt | sort -k1,1 > aligned_clean.txt

echo "Extracting FASTA lengths ..."

seqkit fx2tab -nl $FASTA > fasta_lengths.txt
awk '{print $1 "\t" $NF}' fasta_lengths.txt | sort -k1,1 > fasta_len_clean.txt

echo "Computing mapping coverage ..."

join -1 1 -2 1 aligned_clean.txt fasta_len_clean.txt \
    | awk '{ if ($3>0) {cov=$2/$3} else {cov=0} print $1"\t"$2"\t"$3"\t"cov }' \
    > mapping_coverage.txt

echo "Retrieving poorly aligned transcripts ..."

awk '$2 < 100 || $4 < 0.20' mapping_coverage.txt > poorly_aligned_ids.txt

###############################################################################
# 3) Retrieve non-aligned transcripts
###############################################################################

echo "Retrieving non-aligned transcripts ..."

grep "^>" $FASTA | sed 's/^>//' | awk '{print $1}' > all_ids.txt
awk '{print $1}' mapping_coverage.txt | sort -u > mapped_ids.txt

comm -23 <(sort all_ids.txt) <(sort mapped_ids.txt) > not_aligned_ids.txt

###############################################################################
# 4) Filter the assembly
###############################################################################

echo "Filtering assembly ..."

cat chimera_ids_clean.txt poorly_aligned_ids.txt not_aligned_ids.txt \
    | awk '{print $1}' | sort -u > remove_ids.txt

seqkit grep -v -f remove_ids.txt $FASTA > Trinity95_rnasep2_clean.fasta

# Remove sequences <200 bp
seqkit seq -m 200 Trinity95_rnasep2_clean.fasta > Trinity95_rnasep2_clean_min200.fasta

echo "Done!"
