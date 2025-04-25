
library(DESeq2)
library(pcaExplorer)
library(ggplot2)
library(tidyr)
library(dplyr)
library(tibble)
library(pheatmap)

meta <- read.table("configFiles/Design_Deseq.tsv", header = T, sep="\t")

meta <- meta %>%
  mutate(SampleName = paste(SampleName,"-",Treatment)) %>%
  filter(Treatment == "CT7.7" | Treatment == "Hg8.1")
rownames(meta) <-  meta$SampleName
meta$pCO2 <- factor(meta$pCO2, levels=c("7.7"))

View(meta)


star <- DESeqDataSetFromHTSeqCount(sampleTable = meta,
                           directory = "data/analyseDiff",
                           design = ~ Treatment)

star <- estimateSizeFactors(star)
star <- estimateDispersions(star)

idx <- rowSums(counts(star,normalized=TRUE) >= 10 ) >= 1
star <- star[idx,]


star_test <- DESeq(star)
vsd <- vst(star_test)

pcaData <- plotPCA(vsd, intgroup=c("Treatment"), returnData=TRUE, ntop=300) # Performing PCA using the 1000 more variable genes
percentVar <- round(100 * attr(pcaData, "percentVar"))

ggplot(pcaData, aes(PC1, PC2, color=Treatment)) + # Plotting the PCA
  geom_point(size=4) +
  scale_color_manual(values=c("lightblue", "lightgreen")) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  theme(axis.title = element_text(size=8),
        legend.title = element_text(size=8)) +
  labs(color="Condition") +
  coord_fixed() +
  theme(text=element_text(size=8)) +
  theme_bw()



dds <- DESeq(star, test="Wald")
resultsNames(dds)
resPed<-results(dds, name="Treatment_Hg8.1_vs_CT7.7")
View(resPed)
Diff_Hg <- resPed %>% # This objet contains every genes influences by pedigree
  data.frame() %>%
  rownames_to_column(var="ID") %>%
  arrange(padj) %>%
  filter(padj<0.05,
         abs(log2FoldChange) > 0.5) %>%
  dplyr::select(ID, log2FoldChange)
View(Diff_Hg)
dds[1:100,]


vsd <- vst(dds)
a <- assay(vsd) %>%
  as.data.frame() %>%
  rownames_to_column(var="ID") %>%
  filter(ID %in% Diff_Hg$ID)

rownames(a)=a$ID

Matrix <- a %>%
  dplyr::select(-ID)

pheatmap((Matrix), # Modify parameters as convenience
         cluster_cols=TRUE,
         clustering_distance_rows = "correlation",
         clustering_distance_cols = "euclidean",
         cluster_rows=TRUE,
         scale="row",
         border_color = "grey",
         cutree_rows = 1,
         cutree_cols = 2,
         drop_levels = TRUE,
         legend=FALSE,
         fontsize = 9,
         cellwidth =20,
         angle_col=45)
