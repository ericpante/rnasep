
library(DESeq2)
library(pcaExplorer)
library(ggplot2)
library(tidyr)
library(dplyr)
library(tibble)
library(pheatmap)
library(wesanderson)

meta <- read.table("configFiles/Design_Deseq1.tsv", header = T, sep="\t")

meta <- meta# %>%
  #filter(Treatment == "CT8.1" | Treatment == "Hg7.7")
rownames(meta) <-  meta$SampleName

View(meta)
meta$pCO2 <- as.factor(meta$pCO2)

star <- DESeqDataSetFromHTSeqCount(sampleTable = meta,
                           directory = "data/analyseDiff",
                           design = ~ Mercury + pCO2 + pCO2:Mercury)

STAR <- DESeqDataSetFromHTSeqCount(sampleTable = meta,
                                   directory = "data/analyseDiff",
                                   design = ~ Treatment)

star <- estimateSizeFactors(star)
star <- estimateDispersions(star)


idx <- rowSums(counts(star,normalized=TRUE) >= 10 ) >= 1
star <- star[idx,]


dds <- DESeq(star, test="LRT", reduced = ~Mercury + pCO2)

resultsNames(dds)

HgEffect <- results(dds, name="Mercury_Hg_vs_CT")

HgEffect <- HgEffect %>% # This objet contains every genes influences Treatment
  data.frame() %>%
  rownames_to_column(var = "ID") %>%
  arrange(padj) %>%
  filter(padj < 0.05 &
           abs(log2FoldChange) > 0.5) %>%
  select(ID, log2FoldChange)

nrow(HgEffect)

CO2Effect <- results(dds, name="pCO2_8.1_vs_7.7")

CO2Effect <- CO2Effect %>% # This objet contains every genes influences Treatment
  data.frame() %>%
  rownames_to_column(var = "ID") %>%
  arrange(padj) %>%
  filter(padj < 0.05 &
           abs(log2FoldChange) > 0.5) %>%
  select(ID, log2FoldChange)

nrow(CO2Effect)

Int <- results(dds, name="MercuryHg.pCO28.1")

Int <- Int %>% # This objet contains every genes influences Treatment
  data.frame() %>%
  rownames_to_column(var = "ID") %>%
  arrange(padj) %>%
  filter(padj < 0.05 &
           abs(log2FoldChange) > 0.5) %>%
  select(ID, log2FoldChange)

nrow(Int)

DDS <- DESeq(STAR)
STAR$Treatment <- relevel(STAR$Treatment, ref="CT8.1")
resultsNames(DDS)
Hg <- results(DDS, name = "Treatment_Hg7.7_vs_CT8.1")

Hg <- Hg %>% # This objet contains every genes influences Treatment
  data.frame() %>%
  rownames_to_column(var = "ID") %>%
  arrange(padj) %>%
  filter(padj < 0.05 &
           abs(log2FoldChange) > 0.5) %>%
  select(ID, log2FoldChange)

nrow(Hg)








# Trying to build co-expression network
library(WGCNA)
library(fastcluster)

STAR <- tar_read(star)
STAR <- estimateSizeFactors(STAR)
vsd <- vst(star)




exp <- assay(vsd) %>%
  t()
View(exp)

geneVars <- apply(exp, 2, var)
topGenes <- names(sort(geneVars, decreasing = TRUE)[1:10000])
expFilt <- exp[, topGenes]

gsg <- goodSamplesGenes(expFilt)
summary(gsg)
gsg$allOK

sampleTree <- hclust(dist(expFilt), method="average")
par(cex=0.6);
par(mar=c(0,4,2,0))
plot(sampleTree, main="Sample clustering to detect outliers", sub="",
     xlab="", cex.lab=1.5, cex.axis=1.5, cex.main=2)
abline(h=104, col="red")

cut.sampleTree <- cutreeStatic(sampleTree, cutHeight=125, minSize=10)
expFiltOut <- expFilt[cut.sampleTree==1,]

spt <- pickSoftThreshold(expFiltOut)
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

net <- blockwiseModules(
  expFiltOut,
  power = softPower,
  TOMType = "signed",              # ou "unsigned" ou "signed hybrid"
  minModuleSize = 30,              # taille min d’un module
  reassignThreshold = 0,           # évite de reclasser les gènes
  mergeCutHeight = 0.25,           # seuil de fusion des modules
  numericLabels = FALSE,            # modules numérotés au lieu de couleurs
  pamRespectsDendro = FALSE,       # améliore la détection de modules
  saveTOMs = TRUE,
  verbose = 3
)

#adjacency <- adjacency(expFiltOut, power=softPower)

#kTotal <- softConnectivity(exp, power = softPower)
#hist(kTotal, breaks=50, main="Histogram of Gene Connectivity", xlab="Connectivity (k)")
# Module Construction
# Topological Overlap Matrix
#TOM <- TOMsimilarity(adjacency) # Similarity
#TOM.dissimilarity <- 1-TOM # Dissimilarity

# Hierarchical Clustering Analysis
#geneTree <- hclust(as.dist(TOM.dissimilarity), method="average")

#sizeGrWindow(12,9)
#plot(geneTree, xlab="", sub="", main = "Gene clustering on TOM-based dissimilarity", 
#     labels = FALSE, hang = 0.04)

#Modules <- cutreeDynamic(dendro=geneTree, distM=TOM.dissimilarity, deepSplit = 2, pamRespectsDendro = FALSE, minClusterSize = 30)

ModuleColors <- labels2colors(tar_read(net)$colors)#assigns each module number a color
names(ModuleColors) <- colnames(tar_read(ExpFiltOut))

table(ModuleColors) #returns the counts for each color (aka the number of genes within each module)

#plots the gene dendrogram with the module colors
plotDendroAndColors(net$dendrograms[[1]], ModuleColors[net$blockGenes[[1]]],"Module",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05,
                    main = "Gene dendrogram and module colors")

# Module Eigengene Identification
MElist <- moduleEigengenes(expFiltOut, colors = ModuleColors)
MEs <- MElist$eigengenes
head(MEs)

# Module Merging
ME.dissimilarity = 1-cor(MEs, use="complete") #Calculate eigengene dissimilarity

METree = hclust(as.dist(ME.dissimilarity), method = "average") #Clustering eigengenes 
par(mar = c(0,4,2,0)) #seting margin sizes
par(cex = 0.6);#scaling the graphic
plot(METree)
abline(h=.25, col = "red") #a height of .25 corresponds to correlation of .75

merge <- mergeCloseModules(expFiltOut, ModuleColors, cutHeight = .25)

# The merged module colors, assigning one color to each module
mergedColors = merge$colors
# Eigengenes of the new merged modules
mergedMEs = merge$newMEs

plotDendroAndColors(net$dendrograms[[1]], cbind(ModuleColors[net$blockGenes[[1]]], mergedColors[net$blockGenes[[1]]]), 
                    c("Original Module", "Merged Module"),
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05,
                    main = "Gene dendrogram and module colors for original and merged modules")

# External Trait Matching
ExtTraits <- read.delim("data/analyseDiff/Other/ExternalTraits.csv", sep=";", dec=",")
View(ExtTraits)


datTraits <- ExtTraits %>%
  filter(SampleName %in% rownames(expFiltOut))
rownames(datTraits)<- datTraits$SampleName
datTraits <- datTraits[,-1]




# Module-trait associations
# Define numbers of genes and samples
nGenes = ncol(expFiltOut)
nSamples = nrow(expFiltOut)
module.trait.correlation = cor(mergedMEs, datTraits, use = "p") #p for pearson correlation coefficient 
module.trait.Pvalue = corPvalueStudent(module.trait.correlation, nSamples) #calculate the p-value associated with the correlation

# Will display correlations and their p-values
textMatrix = paste(signif(module.trait.correlation, 2), "\n(",
                   signif(module.trait.Pvalue, 1), ")", sep = "");
dim(textMatrix) = dim(module.trait.correlation)
par(mar = c(6, 8.5, 3, 1))
# Display the correlation values within a heatmap plot
labeledHeatmap(Matrix = module.trait.correlation,
               xLabels = names(datTraits),
               yLabels = names(mergedMEs),
               ySymbols = names(mergedMEs),
               colorLabels = FALSE,
               colors = blueWhiteRed(50),
               textMatrix = textMatrix,
               setStdMargins = FALSE,
               cex.text = 0.6,
               zlim = c(-1,1),
               main = paste("Module-trait relationships"))

# Define variable uniform containing the UniformScore column of datTrait
uniform = as.data.frame(tar_read(ExtTraits)$UniformScore)
names(uniform) = "uniform"

modNames = substring(names(tar_read(mergedMEs)), 3) #extract module names

#Calculate the module membership and the associated p-values
geneModuleMembership = as.data.frame(cor(tar_read(ExpOut), tar_read(mergedMEs), use = "p"))
MMPvalue = as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nSamples))
names(geneModuleMembership) = paste("MM", modNames, sep="")
names(MMPvalue) = paste("p.MM", modNames, sep="")

#Calculate the gene significance and associated p-values
geneTraitSignificance = as.data.frame(cor(tar_read(Exp), uniform, use = "p"))
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples))
names(geneTraitSignificance) = paste("GS.", names(uniform), sep="")
names(GSPvalue) = paste("p.GS.", names(uniform), sep="")
head(GSPvalue)

par(mar=c(1,1,1,1))
module = "grey60"
column = match(module, modNames)
moduleGenes = tar_read(mergeColors)==module
verboseScatterplot(abs(geneModuleMembership[moduleGenes,column]),
                   abs(geneTraitSignificance[moduleGenes,1]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = "Gene significance for Uniform Score",
                   main = paste("Module membership vs. gene significance\n"),
                   cex.main = 1.2, cex.lab = 1.2, cex.axis = 1.2, col = module)


# Now, for each module of interest, choose the genes with a MM higher than 0.8

UniformHubGenes <- geneModuleMembership %>%
  dplyr::select(MMmaroon) %>%
  dplyr::filter(MMmaroon >= 0.8)



tar_read(HubGeneMaroon) %>%
  ggplot(aes(x=MMmaroon)) +
  geom_histogram()


renv::install("KOGMWU")
library(KOGMWU)

gene2kog <- tar_read(KOGforMWU) %>%
  as.data.frame() %>%
  filter(Transcript %in% Modulegenes$ID)

Modulegenes <- tar_read(MaroonforMWU1) %>%
  as.data.frame()
View(Modulegenes)
gene_vector <- setNames(Modulegenes$Value, Modulegenes$ID)

Maroon.lth<-kog.mwu(Modulegenes,gene2kog)
View(Maroon.lth)

kogtable.rna <- makeDeltaRanksTable(list("Maroon.lth"=Maroon.lth))
kogtable.rna

library(pheatmap)
mat <- as.matrix(kogtable.rna)
mat <- mat[complete.cases(mat),]
summary(mat)

pheatmap(mat,
         #clustering_distance_cols="correlation",
         treeheight_row=15,
         treeheight_col=15,
         border_color="white")

plot(kogtable.rna$Maroon.lth)
View(Maroon.lth)

b <- read.delim("configFiles/KOG_class.txt") %>%
  as.data.frame()


load("blockwiseTOM-block.1.RData")

TOMmat <- as.matrix(TOM)

colnames(TOMmat) <- geneNames
rownames(TOMmat) <- geneNames

module <- "blue"
blockGenes <- tar_read(net)$blockGenes[[1]]
geneNames <- colnames(tar_read(ExpFiltOut))[blockGenes]

moduleColorsBlock <- labels2colors(tar_read(net)$colors[blockGenes])
names(moduleColorsBlock) <- geneNames

moduleGenes <- geneNames[moduleColorsBlock == module]

moduleIndices <- which(geneNames %in% moduleGenes)
TOM_module <- TOM[moduleIndices, moduleIndices]


# Récuprérer noms de gènes d'un module donné

Annot <- tar_read(AnnotationFile)
a <- tar_read(mergeColors) %>%
  as.data.frame() %>%
  tibble::rownames_to_column(var="Gene") %>%
  dplyr::filter(. == "blue")

valid_mapping <- Annot[!is.na(Annot$ProteinCode) & Annot$ProteinCode != "-",]
transcript_to_preferred <- setNames(valid_mapping$ProteinCode, valid_mapping$Transcript)

a$Gene <- ifelse(a$Gene %in% names(transcript_to_preferred),
                       transcript_to_preferred[a$Gene],
                 a$Gene)



A <- a %>%
  filter(Gene %in% Annot$ProteinCode) %>%
  select(Gene)


b <- tar_read(mergeColors)
moduleGenes <- names(b)[b == "blue"]

file <- read.delim("mRNA_only.rnasep1.gff3", header=FALSE)

A <- as.data.frame(sub(".*ID=([^~]+);.*", "\\1", file$V9))
write.table(A, file="mRNA.lst", col.names = FALSE, row.names = FALSE, quote = FALSE)


View(tar_read(dds1))




Colors <- tar_read(mergeColors)
Annot <- tar_read(AnnotationFile)


Col <- Colors %>%
  as.data.frame() %>%
  rownames_to_column(var = "Gene") %>%
  dplyr::filter(. == "tan")

valid_mapping <- Annot[!is.na(Annot$ProteinCode) & Annot$ProteinCode != "-", ]
transcript_to_preferred <- setNames(valid_mapping$ProteinCode, valid_mapping$Transcript)

Col$Gene <- ifelse(Col$Gene %in% names(transcript_to_preferred),
                   transcript_to_preferred[Col$Gene],
                   Col$Gene
)

selected_genes <- Col[, 1]
colnames(Col) <- c("Gene", "Module")

ColData <- setNames(Col$Module, Col$Gene)

View(Col)

write.csv(Col, file="results/AnalyseDiff/files/TanModuleGenes.csv", quote=FALSE, row.names = FALSE)
