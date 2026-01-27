# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

rm(list = ls())
# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(visNetwork)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("readxl", "dplyr", "tidyverse", "DESeq2", "ggplot2", "pheatmap", "pcaExplorer", "RColorBrewer", "VennDiagram", "wesanderson", "ggvenn", "WGCNA") # Packages that your targets need for their tasks.
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
tar_source("R/AnalyseDiff/00-Annotation.R")
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



list(
  ################################################################################################################################################
  ########################################################## HgCO2 vs CT #########################################################################
  ################################################################################################################################################
  tar_target(AnnotationFile, BuildAnnot("configFiles/mpibr_sepoff_v1.emapper.annotations.xlsx", "configFiles/mpibr_sepoff_v1_annotations.tsv")), # Import & read Annotation file 
  ################################################################################################################################################
  ################################################################################################################################################
  tar_target(file, "configFiles/Design_Deseq1.tsv"),                                                                                             # Script 1
  tar_target(meta, ReadMeta(file)),                                                                                                              # Read and prepare SampleTable
  tar_target(sampleTable1, tidyMeta2(meta)),                                                                                                     #
  ################################################################################################################################################
  ################################################################################################################################################
  tar_target(directory, "data/analyseDiff/GenomeBased"),                                                                                         # Script 2
  tar_target(star1, BuildDESeq(ST = sampleTable1, DIR = directory, DES=~Treatment, relevel_treatment = TRUE, factor_treatment = TRUE)),          # Build the DESeq object from counts files
  ################################################################################################################################################
  ################################################################################################################################################
  tar_target(dds1, DEanalysis(star1, "Wald")),                                                                                                   # Script3
  tar_target(DEG1, RetrieveDEG(dds1, "Treatment_Hg7.7_vs_CT8.1", 0.5)),                                                                          # Running DE analysis and retrieving DEGs
  tar_target(DEG1annot, AnnotDE(DEG1, AnnotationFile)),                                                                                          # 475 DEGs
  ################################################################################################################################################
  ################################################################################################################################################
  tar_target(Heat1, HeatDEG(dds1, X=c("5","6","8","9","37","38","80","28","30","31","32","68"), DEG1, AnnotationFile, 2, 2, 7, rows = FALSE)),   # Scripts 4 & 5
  tar_target(ExportHeat1, PlotExport("results/Analysediff/figures/HgCO2_heatmap.png", Heat1, W=5, H=7, U="in")),                                 # Build & export heatmap of DEGs
  ################################################################################################################################################
  ################################################################################################################################################
  ################################################################################################################################################
  ################################################################################################################################################
  tar_target(GOforMWU1, goMWU(dds1, "Treatment_Hg7.7_vs_CT8.1", AnnotationFile)),                                                                #
  tar_target(GENEforMWU1, geneMWU(dds1, "Treatment_Hg7.7_vs_CT8.1", 0.5, GOforMWU1)),                                                            # Script 6
  tar_target(GOTable, ExportGO(GOforMWU1, "R/AnalyseDiff/GOMWU/GeneToGO.tab")),                                                                  # Build & Export Go & Gene files to be used by GOMWU (external scripts, cf. https://github.com/z0on/GO_MWU)
  tar_target(GENEtable1, ExporteGENE(GENEforMWU1, "R/AnalyseDiff/GOMWU/GeneToValue.csv")),                                                       #
  ################################################################################################################################################
  ########################################################### Hg vs CT ###########################################################################
  ################################################################################################################################################
  tar_target(DEG2, RetrieveDEG(dds1, "Treatment_Hg8.1_vs_CT8.1", 0.5)),                                                                          # Script3
  tar_target(DEG2annot, AnnotDE(DEG2, AnnotationFile)),                                                                                          # Retrieving DEGs
  ################################################################################################################################################ 8 DEGs
  ################################################################################################################################################
  tar_target(Heat2, HeatDEG(dds1, X=c("5","6","8","9","37","38","80","19","20","21","24","25","55","56"), DEG2, AnnotationFile, 2, 2, 7, rows=FALSE)),# Scripts 4 & 5
  tar_target(ExportHeat2, PlotExport("results/Analysediff/figures/Hg_heatmap.png", Heat2, W=5, H=3, U="in")),                                    # Build & export heatmap of DEGs
  ################################################################################################################################################ Too few DEGs so don't need to go further on functional enrichement analysis.
  ######################################################### CO2 vs CT ############################################################################
  ################################################################################################################################################
  tar_target(DEG3, RetrieveDEG(dds1, "Treatment_CT7.7_vs_CT8.1", 0.5)),                                                                          # Script3
  tar_target(DEG3annot, AnnotDE(DEG3, AnnotationFile)),                                                                                          # Retrieving DEGs
  ################################################################################################################################################ 30 DEGs
  ################################################################################################################################################
  tar_target(Heat3, HeatDEG(dds1, X=c("5","6","8","9","37","38","80","10","11","12","13","46","48","85","86"), DEG3, AnnotationFile, 2, 2, 7, rows=FALSE)), # Scripts 4 & 5
  tar_target(ExportHeat3, PlotExport("results/Analysediff/figures/CO2_heatmap.png", Heat3, W=5, H=3, U="in")),                                   # Build & export heatmap of DEGs
  ################################################################################################################################################ Too few DEGs so don't need to go further on functional enrichement analysis.
  ############################################################## ALL #############################################################################
  ################################################################################################################################################
  tar_target(SumDEGplot, SumDEG(DEG1, DEG2, DEG3)),                                                                                              #
  tar_target(SumDEGExport, PlotExport("results/Analysediff/figures/SumDEG.png", SumDEGplot, W=5, H=5, U="in")),                                  #
  ################################################################################################################################################
  tar_target(VennData, BuildVennData(DEG1, DEG2, DEG3)),                                                                                         #
  tar_target(VennDiagram, displayVenn(VennData)),                                                                                                #
  tar_target(ExportVenn, PlotExport("results/AnalyseDiff/figures/VennDEGS.png", VennDiagram, W=5, H=5, U="in")),                                 # 
  ################################################################################################################################################
  ################################################################################################################################################
  tar_target(file2, "results/AnalyseDiff/files/HgCO2_BP_best_results.txt"),                                                                      #
  tar_target(HgCO2_GOMWU_BP, loadGOMWU(file2)),                                                                                                  # Script 08
  tar_target(HgCO2_BP_Plot, PlotGOMWU(HgCO2_GOMWU_BP)),                                                                                          # Computing/Plotting GOMWU results
  tar_target(ExportHgCO2_BP_Plot, PlotExport("results/AnalyseDiff/figures/HgCO2_BP.png", HgCO2_BP_Plot, W=7, H=6.5, U="in")),                    #
  tar_target(file2a, "results/AnalyseDiff/files/HgCO2_BP_all_results.txt"),                                                                      #
  tar_target(HgCO2_GOMWU_BP.all, loadGOMWU(file2a)),                                                                                             #
  tar_target(gene2go.DEG, gomwu2deg(DEG1, AnnotationFile, GOforMWU1,HgCO2_GOMWU_BP.all)),                                                        # find the DEGs involved in GOMWU signal (n=52).
  #################################################################################################################################################### 
  ####################################################################################################################################################
  
  
  
  ####################################################################################################################################################
  ############################################ WGCNA #################################################################################################
  ####################################################################################################################################################
  tar_target(meta2, tidyMeta(meta)),                                                                                                                 #
  tar_target(star, BuildDESeq(ST = meta2, DIR = directory, DES=~Treatment, relevel_treatment = FALSE)),                                              #
  tar_target(exp, StarToExp(star1)),                                                                                                                 #
  tar_target(ExprFilt, ExpFilt(exp)),                 # To keep top 5000 more variable genes                                                         #
  tar_target(check, checkSamples(ExprFilt)),          # If TRUE -> Don't need to remove outliers (then forget the three next targets).                                                    #
  #tar_target(sampleTree, findOut(ExprFilt)),                                                                                                        # Script 09
  #tar_target(PlotTree, plotTree("results/AnalyseDiff/figures/SampleTree.png", sampleTree, H = 64), format = "file"),                                # Building coexpression network
  #tar_target(ExpFiltOut, rmOut(sampleTree, ExprFilt, H = 59)),                                                                                      #
  tar_target(spt, softThres(ExprFilt)),                                                                                                              #
  tar_target(R2, plotR2("results/AnalyseDiff/figures/R2.png", spt), format = "file"),                                                                #
  tar_target(meanConnect, plotConnect("results/AnalyseDiff/figures/meanConnect.png", spt), format = "file"),                                         #
  # tar_target(Adj, Adjacency(ExprFilt, 8)),                                                                                                         # Adj is the weighted gene co-expression network and contains 23,106 nodes (genes).
  tar_target(net, moduleConstruct(ExprFilt, 7)),                                                                                                     # Automatic construction of modules - can avoid the three next targets, go line 138.
  #################################################################################################################################################################
  #################################################################################################################################################################
  # tar_target(TOM.dissim,TOMdissim(Adj)),                                                                                                                        #
  # tar_target(geneTree, TreeGene(TOM.dissim)),                                                                                                                   #
  # tar_target(ME, BuildModules(geneTree, TOM.dissim)),                                                                                                           #
  tar_target(ModuleColors, MEColors(net, ExprFilt)),                                                                                                              #
  tar_target(ME.dissim, MEdissim(ExprFilt, ModuleColors)),                                                                                                        # Script 10
  tar_target(merged, mergeModules(ExprFilt, ModuleColors)),                                                                                                       # Constructing Eigengene modules
  tar_target(mergedMEs, retrieveMergedME(merged)),                                                                                                                #
  tar_target(mergeColors, retrieveMergedColors(obj = merged, ModuleColors)),                                                                                      #
  tar_target(DendroColors, plotDendroColors(net, ModuleColors, mergeColors, "results/AnalyseDiff/figures/dendroColors.png"), format = "file"),                    #
  #################################################################################################################################################################
  ########################################################################################################################################################################
  tar_target(file3, "data/analyseDiff/Other/ExternalTraits.csv"),                                                                                                        #
  tar_target(ExtTraits, loadTraits(path = file3, SEP = ";", DEC = ",", Exp.Matrix = ExprFilt)),                                                                          # Script 11
  tar_target(CorrelationMatrix, ModTraitCor(ExprFilt, mergedMEs, ExtTraits)),                                                                                            # Matching eigengene modules and traits
  tar_target(Matrix, plotcor(ExtTraits, mergedMEs, CorrelationMatrix, "results/AnalyseDiff/figures/Module-Traits-Correlation.png", 12, 10, "in", 300), format = "file"), #
  ########################################################################################################################################################################
  ########################################################################################################################################################################
  tar_target(MMall, ModuleMembership(mergedMEs, ExprFilt)),                                                                                                              #
  tar_target(HubGeneGreenyellow, HubGenes(mergeColors, "greenyellow", MMall, c("MMgreenyellow"), Variable = MMgreenyellow, Percent = 0.90, AnnotationFile)),             # Script 12 - Retrieving Hub Genes for each module eigengene of interest
  tar_target(HubGeneRoyalblue, HubGenes(mergeColors, "royalblue", MMall, c("MMroyalblue"), Variable = MMroyalblue, Percent = 0.95, AnnotationFile)),                     #
  #########################################################################################################################################################################################################################
  #########################################################################################################################################################################################################################
  tar_target(TOM_subGreenyellow, TOMsub(mergeColors, ExprFilt, "greenyellow", 5)),                                                                                                                                        #
  tar_target(exportGreenyellowCytoscape, ExportTOMtoCyto(TOM_subGreenyellow, AnnotationFile, "greenyellow",                                                                                                               #
    PATH1 = "results/analyseDiff/files/WGCNA/GreenyellowCytoscapeEdges.txt",                                                                                                                                              # Export TOM for blue module
    PATH2 = "results/analyseDiff/files/WGCNA/GreenyellowCytoscapeNodes.txt", Colors = mergeColors, THRLD = 0.15), format = "rds"),                                                                                        #
  tar_target(GreenyellowNodeAttr, NodAttr(mergeColors, AnnotationFile, MMall, "greenyellow", Vars = c("Gene", "MMgreenyellow"), PATH = "results/analyseDiff/files/WGCNA/GreenyellowNodeAttributes.txt"), format = "rds"), #
  tar_target(GreenyellowAnnot, AnnotModules(mergeColors, "greenyellow", AnnotationFile)),                                                                                                                                 #
  #########################################################################################################################################################################################################################
  tar_target(TOM_subRoyalblue, TOMsub(mergeColors, ExprFilt, "royalblue", 5)),                                                                                                                                            #
  tar_target(exportRoyalblueCytoscape, ExportTOMtoCyto(TOM_subRoyalblue, AnnotationFile, "royalblue",                                                                                                                     #
                                                         PATH1 = "results/analyseDiff/files/WGCNA/RoyalblueCytoscapeEdges.txt",                                                                                           # Export TOM for blue module
                                                         PATH2 = "results/analyseDiff/files/WGCNA/RoyalblueCytoscapeNodes.txt", Colors = mergeColors, THRLD = 0.15), format = "rds"),                                     #
  tar_target(RoyalblueNodeAttr, NodAttr(mergeColors, AnnotationFile, MMall, "royalblue", Vars = c("Gene", "MMroyalblue"), PATH = "results/analyseDiff/files/WGCNA/RoyalblueNodeAttributes.txt"), format = "rds"),         #
  tar_target(RoyalblueAnnot, AnnotModules(mergeColors, "royalblue", AnnotationFile)),                                                                                                                                     #
  #########################################################################################################################################################################################################################
  #########################################################################################################################################################################################################################
  tar_target(moduleGO, ModuleGO(AnnotationFile, MMall)),                                                                               #
  tar_target(moduleGOTable, ExportGO(moduleGO, "R/AnalyseDiff/GOMWU/moduleGeneToGO.tab")),                                             #
  tar_target(GreenyellowForMWU, moduleMWU(MMall, TOM_subGreenyellow, value = "MMgreenyellow")),                                        # Export genes & GOs for GOMWU - Blue module   
  tar_target(GreenyellowGENEtable, ExporteGENE(GreenyellowForMWU, "R/AnalyseDiff/GOMWU/GreenyellowGeneToValue.csv")),                  #
  tar_target(RoyalblueForMWU, moduleMWU(MMall, TOM_subRoyalblue, value = "MMroyalblue")),                                              # Export genes & GOs for GOMWU - Blue module   
  tar_target(RoyalblueGENEtable, ExporteGENE(RoyalblueForMWU, "R/AnalyseDiff/GOMWU/RoyalblueGeneToValue.csv")),                        #
  ######################################################################################################################################
  ######################################################################################################################################
  tar_target(file4, "results/AnalyseDiff/files/Blue_BP_results_table.txt"),                                                            #
  tar_target(Blue_GOMWU_BP, loadGOMWU(file4)),                                                                                         # Script 08
  tar_target(Blue_BP_Plot, PlotGOMWU(Blue_GOMWU_BP)),                                                                                  # Computing/Plotting GOMWU results
  tar_target(ExportBlue_BP_Plot, PlotExport("results/AnalyseDiff/figures/Blue_BP.png", Blue_BP_Plot)),                                 # Blue
  ######################################################################################################################################
  tar_target(file5, "results/AnalyseDiff/files/Tan_BP_results_rep_table.txt"),                                                         #
  tar_target(Tan_GOMWU_BP, loadGOMWU(file5)),                                                                                          # Script 08
  tar_target(Tan_BP_Plot, PlotGOMWU(Tan_GOMWU_BP)),                                                                                    # Computing/Plotting GOMWU results
  tar_target(ExportTan_BP_Plot, PlotExport("results/AnalyseDiff/figures/Tan_BP.png", Tan_BP_Plot)),                                    # Tan
  ######################################################################################################################################
  ######################################################################################################################################
  ######################################################################################################################################
  tar_render(Report, path = "Report/RNAsep2_DEanalysis_Report2.Rmd")
)

# Sys.setenv(TAR_PROJECT="AnalyseDiff")

# tar_manifest(fields=command)

# tar_visnetwork(physics=TRUE)

# tar_make(ExportTan_BP_Plot)

# tar_read(Tan_BP_Plot)