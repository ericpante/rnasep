#!/bin/bash

for i in *.tab.tmp
do
    LANG=en_EN sort -k1,1 ${i} > ${i}.tmp
    LANG=en_EN join -1 1 -2 1 mRNA.lst ${i}.tmp | sed 's/ /\t/g' | cut -f1-2 > ${i%Reads*}.counts
done
