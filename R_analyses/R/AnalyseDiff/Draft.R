
library(DESeq2)
library(pcaExplorer)
library(ggplot2)
library(tidyr)
library(dplyr)
library(tibble)
library(pheatmap)

meta <- read.table("configFiles/Design_Deseq1.tsv", header = T, sep="\t")

meta <- meta %>%
  mutate(SampleName = paste(SampleName,"-",Treatment)) %>%
  filter(Treatment == "CT8.1" | Treatment == "Hg7.7")
rownames(meta) <-  meta$SampleName

View(meta)


star <- DESeqDataSetFromHTSeqCount(sampleTable = meta,
                           directory = "data/analyseDiff",
                           design = ~ Treatment)


star <- estimateSizeFactors(star)
star <- estimateDispersions(star)

idx <- rowSums(counts(star,normalized=TRUE) >= 10 ) >= 1
star <- star[idx,]



# Trying to build co-expression network
library(WGCNA)
library(fastcluster)

exp <- assay(star) %>%
  t()
View(exp)

gsg <- goodSamplesGenes(exp)
summary(gsg)
gsg$allOK

sampleTree <- hclust(dist(exp), method="average")
par(cex=0.6);
par(mar=c(0,4,2,0))
plot(sampleTree, main="Sample clustering to detect outliers", sub="",
     xlab="", cex.lab=1.5, cex.axis=1.5, cex.main=2)
abline(h=700000, col="red")

cut.sampleTree <- cutreeStatic(sampleTree, cutHeight=700000, minSize=10)
exp <- exp[cut.sampleTree==1,]

spt <- pickSoftThreshold(exp)
spt
# Plot R^2 values as a function of the soft thresholds
par(mar=c(1,1,1,1))
plot(spt$fitIndices[,1],spt$fitIndices[,2],
     xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
     main = paste("Scale independence"))
text(spt$fitIndices[,1],spt$fitIndices[,2],col="red")
abline(h=0.80,col="red")

# Plot mean connectivity as a function of soft thresholds
par(mar=c(1,1,1,1))
plot(spt$fitIndices[,1], spt$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(spt$fitIndices[,1], spt$fitIndices[,5], labels= spt$fitIndices[,1],col="red")
abline(h=1, col="red")

softPower <- 8
adjacency <- adjacency(exp, power=softPower)

# Module Construction
# Topological Overlap Matrix
TOM <- TOMsimilarity(adjacency) # Similarity
TOM.dissimilarity <- 1-TOM # Dissimilarity

# Hierarchical Clustering Analysis
geneTree <- hclust(as.dist(TOM.dissimilarity), method="average")

sizeGrWindow(12,9)
plot(geneTree, xlab="", sub="", main = "Gene clustering on TOM-based dissimilarity", 
     labels = FALSE, hang = 0.04)

Modules <- cutreeDynamic(dendro=geneTree, distM=TOM.dissimilarity, deepSplit = 2, pamRespectsDendro = FALSE, minClusterSize = 30)

ModuleColors <- labels2colors(Modules) #assigns each module number a color
table(ModuleColors) #returns the counts for each color (aka the number of genes within each module)

#plots the gene dendrogram with the module colors
plotDendroAndColors(geneTree, ModuleColors,"Module",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05,
                    main = "Gene dendrogram and module colors")

# Module Eigengene Identification
MElist <- moduleEigengenes(exp, colors = ModuleColors)
MEs <- MElist$eigengenes
head(MEs)

# Module Merging
ME.dissimilarity = 1-cor(MElist$eigengenes, use="complete") #Calculate eigengene dissimilarity

METree = hclust(as.dist(ME.dissimilarity), method = "average") #Clustering eigengenes 
par(mar = c(0,4,2,0)) #seting margin sizes
par(cex = 0.6);#scaling the graphic
plot(METree)
abline(h=.25, col = "red") #a height of .25 corresponds to correlation of .75

merge <- mergeCloseModules(exp, ModuleColors, cutHeight = .25)

# The merged module colors, assigning one color to each module
mergedColors = merge$colors
# Eigengenes of the new merged modules
mergedMEs = merge$newMEs

plotDendroAndColors(geneTree, cbind(ModuleColors, mergedColors), 
                    c("Original Module", "Merged Module"),
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05,
                    main = "Gene dendrogram and module colors for original and merged modules")






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
