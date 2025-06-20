# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

rm(list=ls())
# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(visNetwork)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("dplyr","tidyverse","DESeq2","ggplot2","pheatmap", "pcaExplorer", "RColorBrewer", "VennDiagram", "wesanderson", "WGCNA") # Packages that your targets need for their tasks.
  # Pipelines that take a long time to run may benefit from
  # optional distributed computing. To use this capability
  # in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller that scales up to a maximum of two workers
  # which run as local R processes. Each worker launches when there is work
  # to do and exits if 60 seconds pass with no tasks to run.
  #
  # Set other options as needed.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/AnalyseDiff/01-ReadMeta.R")
tar_source("R/AnalyseDiff/02-BuildDESeq.R")
tar_source("R/AnalyseDiff/03-DEanalysis.R")
tar_source("R/AnalyseDiff/04-PlotDE.R")
tar_source("R/AnalyseDiff/05-PlotExport.R")
tar_source("R/AnalyseDiff/06-GeneMWU.R")
tar_source("R/AnalyseDiff/07-CompareDEG.R")
tar_source("R/AnalyseDiff/08-PlotGOMWU.R")
tar_source("R/AnalyseDiff/09-CoExpNetwork.R")
tar_source("R/Analysediff/10-ModuleConstruction.R")
tar_source("R/AnalyseDiff/11-MatchExtTraits.R")
tar_source("R/AnalyseDiff/12-RetrieveHubGenes.R")


# Replace the target list below with your own:
list(
##################################################################################################  
########################################## HgCO2 vs CT ###########################################
##################################################################################################
  tar_target(file, "configFiles/Design_Deseq1.tsv"),                                              # Script 1
  tar_target(meta, ReadMeta(file)),                                                              # Read and prepare SampleTable
  tar_target(sampleTable1, tidyMeta(meta, "CT8.1", "Hg7.7")),                                    #
##################################################################################################
##################################################################################################
  tar_target(directory, "data/analyseDiff"),                                                     # Script 2
  tar_target(star1, BuildDESeq(ST = sampleTable1, DIR = directory)),                             # Build the DESeq object from counts files
##################################################################################################
##################################################################################################
  tar_target(dds1, DEanalysis(star1, "Wald")),                                                   # Script3
  tar_target(DEG1, RetrieveDEG(dds1, "Treatment_Hg7.7_vs_CT8.1", 0.5)),                          # Running DE analysis and retrieving DEGs
##################################################################################################
##################################################################################################
  tar_target(Heat1, HeatDEG(dds1, DEG1, 2, 2, rows=FALSE)),                                      # Scripts 4 & 5  
  tar_target(ExportHeat1, PlotExport("results/Analysediff/figures/HgCO2_heatmap.png", Heat1)),   # Build & export heatmap of DEGs
##################################################################################################
##################################################################################################
  tar_target(FullAnnot, "results/Annotation/objects/FullAnnot", format="file"),                  # Import & read Annotation file from the Annotation project
  tar_target(AnnotationFile, readRDS(FullAnnot)),                                                #
##################################################################################################
##################################################################################################
  tar_target(GOforMWU1, goMWU(dds1, "Treatment_Hg7.7_vs_CT8.1", AnnotationFile)),                # 
  tar_target(GENEforMWU1, geneMWU(dds1, "Treatment_Hg7.7_vs_CT8.1", 0.5, GOforMWU1)),            # Script 6
  tar_target(GOTable, ExportGO(GOforMWU1, "R/AnalyseDiff/GOMWU/GeneToGO.tab")),                  # Build & Export Go & Gene files to be used by GOMWU (external scripts, cf. https://github.com/z0on/GO_MWU)
  tar_target(GENEtable1, ExporteGENE(GENEforMWU1, "R/AnalyseDiff/GOMWU/GeneToValue.csv")),       #
##################################################################################################
########################################## Hg vs CT ##############################################
##################################################################################################
  tar_target(sampleTable2, tidyMeta(meta, "CT8.1", "Hg8.1")),                                    #
##################################################################################################
##################################################################################################
  tar_target(star2, BuildDESeq(ST=sampleTable2, DIR=directory)),                                 # 
##################################################################################################
##################################################################################################
  tar_target(dds2, DEanalysis(star2, "Wald")),                                                   # Script3
  tar_target(DEG2, RetrieveDEG(dds2, "Treatment_Hg8.1_vs_CT8.1", 0.5)),                          # unning DE analysis and retrieving DEGs
##################################################################################################
##################################################################################################
  tar_target(Heat2, HeatDEG(dds2, DEG2, 2, 2)),                                                  # Scripts 4 & 5
  tar_target(ExportHeat2, PlotExport("results/Analysediff/figures/Hg_heatmap.png", Heat2)),      # Build & export heatmap of DEGs
################################################################################################## Too few DEGs so don't need to go further on functional enrichement analysis.
########################################## CO2 vs CT #############################################
##################################################################################################
  tar_target(sampleTable3, tidyMeta(meta, "CT8.1", "CT7.7")),                                    #
##################################################################################################
##################################################################################################
  tar_target(star3, BuildDESeq(ST=sampleTable3, DIR=directory)),                                 # 
##################################################################################################
##################################################################################################
  tar_target(dds3, DEanalysis(star3, "Wald")),                                                   # Script3
  tar_target(DEG3, RetrieveDEG(dds3, "Treatment_CT8.1_vs_CT7.7", 0.5)),                          # Running DE analysis and retrieving DEGs
##################################################################################################
##################################################################################################
  tar_target(Heat3, HeatDEG(dds3, DEG3, 2, 2)),                                                  # Scripts 4 & 5
  tar_target(ExportHeat3, PlotExport("results/Analysediff/figures/CO2_heatmap.png", Heat3)),     # Build & export heatmap of DEGs
################################################################################################## Too few DEGs so don't need to go further on functional enrichement analysis.
############################################# ALL ################################################
##################################################################################################
  tar_target(VennData, BuildVennData(DEG1,DEG2,DEG3)),                                           #
  tar_target(VennDiagram, displayVenn(VennData,                                                  #
             category.names=c("HgCO2", "Hg", "CO2"),                                             #
             lwd=2,                                                                              #
             lty=4,                                                                              # Script 07
             fill=c("#81A88D","#7294D4","#E6A0C4"),                                              # Comparing DEGs from the three contrasts
             cex=1.2,                                                                            #
             fontface="italic",                                                                  #
             cat.cex=1.3,                                                                        #
             cat.fontface="bold",                                                                #
             cat.default.pos="outer",                                                            #
             cat.dist=c(0.03, 0.03, 0.03))),                                                     #
  tar_target(ExportVenn, PlotExport("results/AnalyseDiff/figures/VennDEGS.png", VennDiagram)),   #
################################################################################################## 
###########################################################################################################
  tar_target(file2, "results/AnalyseDiff/files/HgCO2_BP_results_table.txt"),                              #
  tar_target(HgCO2_GOMWU_BP, loadGOMWU(file2)),                                                           # Script 08
  tar_target(HgCO2_BP_Plot, PlotGOMWU(HgCO2_GOMWU_BP)),                                                   # Computing/Plotting GOMWU results
  tar_target(ExportHgCO2_BP_Plot, PlotExport("results/AnalyseDiff/figures/HgCO2_BP.png", HgCO2_BP_Plot)), #
#################################################################################################################################################################
############################################ WGCNA ##############################################################################################################
#################################################################################################################################################################
  tar_target(meta2, tidyMeta2(meta)),                                                                                                                           #
  tar_target(star, BuildDESeq(ST=meta2, DIR=directory)),                                                                                                        #
  tar_target(exp, StarToExp(star)),                                                                                                                             #
  tar_target(check, checkSamples(exp)),                                                                                                                         #
  tar_target(sampleTree, findOut(exp)),                                                                                                                         # Script 09
  tar_target(PlotTree, plotTree("results/AnalyseDiff/figures/SampleTree.png",sampleTree), format="file"),                                                       # Building coexpression network
  tar_target(ExpOut, rmOut(sampleTree, exp)),                                                                                                                   #
  tar_target(spt, softThres(ExpOut)),                                                                                                                           #
  tar_target(R2, plotR2("results/AnalyseDiff/figures/R2.png", spt), format="file"),                                                                             #
  tar_target(meanConnect, plotConnect("results/AnalyseDiff/figures/meanConnect.png", spt), format="file"),                                                      #
  tar_target(Adj, Adjacency(ExpOut, 8)),                                                                                                                        # Adj is the weighted gene co-expression networks and contains 23,106 nodes (genes).
#################################################################################################################################################################
#################################################################################################################################################################
  tar_target(TOM.dissim,TOMdissim(Adj)),                                                                                                                        #
  tar_target(geneTree, TreeGene(TOM.dissim)),                                                                                                                   #
  tar_target(ME, BuildModules(geneTree, TOM.dissim)),                                                                                                           #
  tar_target(ModuleColors, MEColors(ME, Adj)),                                                                                                                  #
  tar_target(ME.dissim, MEdissim(ExpOut,ModuleColors)),                                                                                                         # Script 10
  tar_target(merged, mergeModules(ExpOut, ModuleColors)),                                                                                                       # Constructing Eigengene modules
  tar_target(mergedMEs, retrieveMergedME(merged)),                                                                                                              #
  tar_target(mergeColors, retrieveMergedColors(obj=merged, ModuleColors)),                                                                                      #
  tar_target(DendroColors, plotDendroColors(geneTree,ModuleColors,mergeColors,"results/AnalyseDiff/figures/dendroColors.png"), format="file"),                  #
#################################################################################################################################################################
#################################################################################################################################################################
  tar_target(file3, "data/analyseDiff/Other/ExternalTraits.csv"),                                                                                               #
  tar_target(ExtTraits, loadTraits(path=file3, SEP=";", DEC=",", Exp.Matrix=ExpOut)),                                                                           # Script 11
  tar_target(CorrelationMatrix, ModTraitCor(ExpOut,mergedMEs,ExtTraits)),                                                                                       # Matching eigengene modules and traits
  tar_target(Matrix, plotcor(ExtTraits,mergedMEs,CorrelationMatrix,"results/AnalyseDiff/figures/Module-Traits-Correlation.png",12,10,"in",300), format="file"), #
#################################################################################################################################################################
#################################################################################################################################################################
  tar_target(MMall, ModuleMembership(mergedMEs, ExpOut)),                                                                                                       # 
  tar_target(HubGeneMaroon, HubGenes(mergeColors, "maroon", MMall, c("MMmaroon"), Variable=MMmaroon, Percent=0.99, AnnotationFile)),                            # Script 12
  tar_target(HubGeneCoral2, HubGenes(mergeColors, "coral2", MMall, c("MMcoral2"), Variable=MMcoral2, Percent=0.95, AnnotationFile)),                            # Retrieving Hub Genes for each module eigengene of interest
#################################################################################################################################################################
#################################################################################################################################################################
  tar_target(TOM_subMaroon, TOMsub(mergeColors, "maroon", TOM.dissim)),                                                                                         #
  tar_target(exportMaroonCytoscape, ExportTOMtoCyto(TOM_subMaroon, AnnotationFile, "maroon", PATH1="results/analyseDiff/files/MaroonCytoscapeEdges.txt",        # Export TOM for maroon module
                                                    PATH2="results/analyseDiff/files/MaroonCytoscapeNodes.txt", Colors=mergeColors, THRLD=0.21),format = "rds"),
  tar_target(MaroonNodeAttr, NodAttr(mergeColors, AnnotationFile, MMall, "maroon", Vars=c("Gene", "MMmaroon"), PATH="results/analyseDiff/files/MaroonNodeAttributes.txt"), format = "rds"),
#################################################################################################################################################################
  tar_target(TOM_subCoral2, TOMsub(mergeColors, "coral2", TOM.dissim)),
  tar_target(exportCoral2Cytoscape, ExportTOMtoCyto(TOM_subCoral2, AnnotationFile, "coral2", PATH1="results/analyseDiff/files/Coral2CytoscapeEdges.txt",
                                                    PATH2="results/analyseDiff/files/Coral2CytoscapeNodes.txt", Colors=mergeColors, THRLD=0.1),format = "rds"),                     #
  tar_target(Coral2NodeAttr, NodAttr(mergeColors, AnnotationFile, MMall, "coral2", Vars=c("Gene", "MMcoral2"), PATH="results/analyseDiff/files/Coral2NodeAttributes.txt"), format = "rds"),









  tar_target(GSuniform, TraitSignificance(ExtTraits$UniformScore, ExpOut, R=0.5)),                                                                              # 
  tar_target(MaroonUniformGenes, HubGenes(MMuniform, GSuniform, Module=c("Gene", "MMmaroon"), variable=MMmaroon)),                                              # Here: Module=maroon       #
#################################################################################################################################################################                           #
  tar_target(BlackUniformGenes, HubGenes(MMuniform, GSuniform, Module=c("Gene", "MMblack"), variable=MMblack)),                                                 # Here: Module=black        #
#################################################################################################################################################################                           #
  tar_target(Darkorange2UniformGenes, HubGenes(MMuniform, GSuniform, Module=c("Gene", "MMdarkorange2"), variable=MMdarkorange2)),                               # Here: Module=darkorange2  # 
#################################################################################################################################################################                           # UNIFORMSCORE
  tar_target(Bisque4UniformGenes, HubGenes(MMuniform, GSuniform, Module=c("Gene", "MMbisque4"), variable=MMbisque4)),                                           # Here: Module=bisque4      #
#################################################################################################################################################################                           #
  tar_target(SteelblueUniformGenes, HubGenes(MMuniform, GSuniform, Module=c("Gene", "MMsteelblue"), variable=MMsteelblue)),                                     # Here: Module=steelblue    #
#################################################################################################################################################################                           #
  tar_target(Plum3UniformGenes, HubGenes(MMuniform, GSuniform, Module=c("Gene", "MMplum3"), variable=MMplum3)),                                                 # Here: Module=plum3        #
#################################################################################################################################################################
  tar_target(MMbrightness, ModuleMembership(mergedMEs, ExpOut, cols=c("MMskyblue3", "MMcoral2","MMlightcoral"), R=0.8)),
  tar_target(GSbrightness, TraitSignificance(ExtTraits$Brightness, ExpOut, R=04)),
  tar_target(Skyblue3BrightnessGenes, HubGenes(MMbrightness, GSbrightness, Module=c("Gene", "MMskyblue3"), variable=MMskyblue3)),
  tar_target(Coral2BrightnessGenes, HubGenes(MMbrightness, GSbrightness, Module=c("Gene", "MMcoral2"), variable=MMcoral2)),
#################################################################################################################################################################
  tar_render(Report, path="Report/RNAsep2_DEanalysis_Report.Rmd")                                                                                               #
)

# Sys.setenv(TAR_PROJECT="AnalyseDiff")

# tar_manifest(fields=command)

# tar_visnetwork(physics=TRUE)

# tar_make(exportCoral2Cytoscape)

# tar_read(HubGeneCoral2)