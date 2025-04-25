###################################################

# Building DESeq file

###################################################

# Build the DESeq operational file:
BuildDESeq <- function(ST, DIR){
DESeqDataSetFromHTSeqCount(sampleTable = ST,
                             directory = DIR,
                             design = ~ Treatment)
}
