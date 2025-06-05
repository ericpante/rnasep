
library(DESeq2)
library(pcaExplorer)
library(ggplot2)
library(tidyr)
library(dplyr)
library(tibble)
library(pheatmap)

meta <- read.table("configFiles/Design_Deseq1.tsv", header = T, sep="\t")

meta <- meta #%>%
  #filter(Treatment == "CT8.1" | Treatment == "Hg7.7")
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

gsg <- goodSamplesGenes(tar_read(exp))
summary(gsg)
gsg$allOK

sampleTree <- hclust(dist(tar_read(exp)), method="average")
par(cex=0.6);
par(mar=c(0,4,2,0))
plot(sampleTree, main="Sample clustering to detect outliers", sub="",
     xlab="", cex.lab=1.5, cex.axis=1.5, cex.main=2)
abline(h=700000, col="red")

cut.sampleTree <- cutreeStatic(sampleTree, cutHeight=700000, minSize=10)
exp <- tar_read(exp)[cut.sampleTree==1,]

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

# External Trait Matching
ExtTraits <- read.delim("data/analyseDiff/Other/ExternalTraits.csv", sep=";", dec=",")
View(ExtTraits)


datTraits <- ExtTraits %>%
  filter(SampleName != "30") %>%
  filter(SampleName %in% rownames(exp))
rownames(datTraits)<- datTraits$SampleName
datTraits <- datTraits[,-1]




# Module-trait associations
# Define numbers of genes and samples
nGenes = ncol(exp)
nSamples = nrow(exp)
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
               cex.text = 0.4,
               zlim = c(-1,1),
               main = paste("Module-trait relationships"))

# Define variable uniform containing the UniformScore column of datTrait
uniform = as.data.frame(datTraits$UniformScore)
names(uniform) = "uniform"

modNames = substring(names(mergedMEs), 3) #extract module names

#Calculate the module membership and the associated p-values
geneModuleMembership = as.data.frame(cor(exp[-25,], mergedMEs, use = "p"))
MMPvalue = as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nSamples))
names(geneModuleMembership) = paste("MM", modNames, sep="")
names(MMPvalue) = paste("p.MM", modNames, sep="")

#Calculate the gene significance and associated p-values
geneTraitSignificance = as.data.frame(cor(exp[-25,], uniform, use = "p"))
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples))
names(geneTraitSignificance) = paste("GS.", names(uniform), sep="")
names(GSPvalue) = paste("p.GS.", names(uniform), sep="")
head(GSPvalue)

par(mar=c(1,1,1,1))
module = "plum3"
column = match(module, modNames)
moduleGenes = mergedColors==module
verboseScatterplot(abs(geneModuleMembership[moduleGenes,column]),
                   abs(geneTraitSignificance[moduleGenes,1]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = "Gene significance for Uniform Score",
                   main = paste("Module membership vs. gene significance\n"),
                   cex.main = 1.2, cex.lab = 1.2, cex.axis = 1.2, col = module)
