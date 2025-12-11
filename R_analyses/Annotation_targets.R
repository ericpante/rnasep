###############################################################################

# Here is the 'targets' script managing the "Annotation" R workflow.

###############################################################################

rm(list=ls())

# Load packages required to define the pipeline:
library(targets)
library(visNetwork)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("dplyr","tidyr", "readxl", "readr", "ggplot2", "wesanderson", "data.table", "ggvenn", "cowplot", "ontologyIndex"))

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/Annotation/01-Blast_Load_Summarize_Plot.R")
tar_source("R/Annotation/02-PlotExport.R")
tar_source("R/Annotation/03-Blast_tidy.R")
tar_source("R/Annotation/04-eggnog_Load_Tidy_Merge.R")
tar_source("R/Annotation/05-Full_annot.R")
tar_source("R/Annotation/06-ExportFile.R")
tar_source("R/Annotation/07-Reactome_Load_Tidy_Plot.R")
tar_source("R/Annotation/08-GO_Namespace_Correspondance.R")
tar_source("R/Annotation/09-GOsummary.R")
tar_source("R/Annotation/10-SumAnnotation.R")
tar_source("R/Annotation/11-CompareAssembliesVenn.R")
tar_source("R/Annotation/12-CompareSpecific.R")
tar_source("R/Annotation/12-PrepMWU.R")
tar_source("R/Annotation/12-MergePlot.R")


# Replace the target list below with your own:
list(
#########################################################################################  
##################################### RNA SEP2 ##########################################  
################################################################################################ 
  tar_target(file1, "data/annotation/Trinity95_rnasep2_clean_mollusca.outfmt6"),               #
  tar_target(blastMollusca, load_blast(file1)),                                                # Scripts 1 & 2
  tar_target(ePropX, Prep_evalue(blastMollusca)),                                              # Loading, processing & plotting blastx e-values
  tar_target(ePlotX, PlotEvalue(ePropX)),                                                      #
  tar_target(PlotX, PlotExport("results/Annotation/figures/BlastMollusca.eValue.jpg",ePlotX)), #
################################################################################################
  tar_target(file2, "data/annotation/Trinity95_rnasep2_clean.outfmt6"),                 #
  tar_target(blastp, load_blast(file2)),                                                # Scripts 1 & 2
  tar_target(ePropP, Prep_evalue(blastp)),                                              # Loading, processing & plotting blastp e-values
  tar_target(ePlotP, PlotEvalue(ePropP)),                                               #
  tar_target(PlotP, PlotExport("results/Annotation/figures/BlastP.eValue.png",ePlotP)), #
#########################################################################################
#########################################################################################
  tar_target(P, Tidy_blast(blastp, blastMollusca, filter_on=TRUE)),                     # Script 3
  tar_target(X, Tidy_blast(blastMollusca, blastp, filter_on=FALSE)),                    # Tidying & merging blastp mollusca and blastp all annotations 
  tar_target(BlastAnnot, Blast_annot(X,P)),                                             # 
#########################################################################################
#########################################################################################
  tar_target(file3,"data/annotation/rnasep2_clean_Trinity95.emapper.annotations.xlsx"), #
  tar_target(eggnog, load_eggnog(file3)),                                               # Script 4 
  tar_target(EggnogAnnot, Tidy_eggnog(eggnog)),                                         # Loading, tidying & merging EggNOG and EggNOG.nt outputs
#########################################################################################
###############################################################################################################################
  tar_target(swissGO.SEP2, SwissGO("data/annotation/sep2_clean_mollusca.swissprot_hit2GO.tab", "data/annotation/sep2_clean.swissprot_hit2GO.tab" )),   # Scripts 5 & 6
  tar_target(FullAnnot, Full_annot(BlastAnnot, EggnogAnnot, swissGO.SEP2)),
  tar_target(FinalAnnot, FileExport(FullAnnot, "results/Annotation/files/rnasep2_Trinity95_clean_FunctionalAnnotation.csv")), # Building & exporting full annotation file
###############################################################################################################################
###########################################################################################################
  tar_target(file6, "configFiles/go.obo.rtf"),                                                            #
  tar_target(GOterms, extract_GO_terms_and_namespaces(file6)),                                            # Script 8 & 9
  tar_target(GO_summary, summarizeGO(FullAnnot, GOterms)),                                              # Building and plotting main GO terms of each Namespace
  tar_target(GOPlot, PlotGO(GO_summary,"biological_process","molecular_function","cellular_component")),  #
  tar_target(ExportGO, PlotExport("results/Annotation/figures/MainGOterms.png", GOPlot)),                 #
###########################################################################################################
###########################################################################################################
  tar_target(SumPlot, SumAnnotation(FullAnnot, ORF=44233)),                                                          # Scripts 10 & 2
  tar_target(ExportSum, PlotExport("results/Annotation/figures/SumAnnotation.png", SumPlot)),             # Calculating & plotting the percentage of transscripts that are annotated
###########################################################################################################
###########################################################################################################
########################################################################################################### 
##################################### RNA SEP1 #########################################################
########################################################################################################
########################################################################################################
  tar_target(file7, "data/annotation/Trinity95_rnasep1_clean_mollusca.outfmt6"),                               #
  tar_target(blastMollusca.SEP1, load_blast(file7)),                                                          # Scripts 1 & 2
  tar_target(ePropX.SEP1, Prep_evalue(blastMollusca.SEP1)),                                                   # Loading, processing & plotting blastx e-values SEP1
  tar_target(ePlotX.SEP1, PlotEvalue(ePropX.SEP1)),                                                    #
  tar_target(PlotX.SEP1, PlotExport("results/Annotation/figures/BlastMollusca.eValue.SEP1.png",ePlotX.SEP1)), #
########################################################################################################
  tar_target(file8, "data/annotation/Trinity95_rnasep1_clean.outfmt6"),                                #
  tar_target(blastp.SEP1, load_blast(file8)),                                                          # Scripts 1 & 2
  tar_target(ePropP.SEP1, Prep_evalue(blastp.SEP1)),                                                   # Loading, processing & plotting blastp e-values SEP1
  tar_target(ePlotP.SEP1, PlotEvalue(ePropP.SEP1)),                                                    #
  tar_target(PlotP.SEP1, PlotExport("results/Annotation/figures/BlastP.eValue.SEP1.png",ePlotP.SEP1)), #
########################################################################################################
  tar_target(P.SEP1, Tidy_blast(blastp.SEP1, blastMollusca.SEP1, filter_on=TRUE)),                     # Script 3
  tar_target(X.SEP1, Tidy_blast(blastMollusca.SEP1, blastp.SEP1, filter_on=FALSE)),                    # Tidying & merging blastx and blastp annotations SEP1
  tar_target(BlastAnnot.SEP1, Blast_annot(X.SEP1,P.SEP1)),                                             #
########################################################################################################
#########################################################################################
  tar_target(file9,"data/annotation/rnasep1_clean_Trinity95.emapper.annotations.xlsx"), #
  tar_target(eggnog.SEP1, load_eggnog(file9)),                                          # Script 4
  tar_target(EggnogAnnot.SEP1, Tidy_eggnog(eggnog.SEP1)),                               # Loading, tidying & merging EggNOG and EggNOG.nt outputs SEP1
#########################################################################################
#########################################################################################################################################
  tar_target(swissGO.SEP1, SwissGO("data/annotation/sep1_clean_mollusca.swissprot_hit2GO.tab", "data/annotation/sep1_clean.swissprot_hit2GO.tab" )),   # Scripts 5 & 6
  tar_target(FullAnnot.SEP1, Full_annot(BlastAnnot.SEP1,EggnogAnnot.SEP1, swissGO.SEP1)),                                                              # Scripts 5 & 6
  tar_target(FinalAnnot.SEP1, FileExport(FullAnnot.SEP1, "results/Annotation/files/rnasep1_Trinity95_clean_FunctionalAnnotation.csv")), # Building & exporting full annotation file SEP1
#########################################################################################################################################
#####################################################################################################################
  tar_target(GO_summary.SEP1, summarizeGO(FullAnnot.SEP1, GOterms)),                                              # Script 8 & 9
  tar_target(GOPlot.SEP1, PlotGO(GO_summary.SEP1,"biological_process","molecular_function","cellular_component")),  # Building and plotting main GO terms of each Namespace SEP1
  tar_target(ExportGO.SEP1, PlotExport("results/Annotation/figures/MainGOterms.SEP1.png", GOPlot.SEP1)),            #
#####################################################################################################################
#########################################################################################################
  tar_target(SumPlot.SEP1, SumAnnotation(FullAnnot.SEP1, ORF=35590)),                                              # Scripts 10 & 2
  tar_target(ExportSum.SEP1, PlotExport("results/Annotation/figures/SumAnnotation.SEP1.png", SumPlot.SEP1)), # Calculating & plotting the percentage of transsccripts that are annotated
#########################################################################################################
#########################################################################################################
###############################################################################################
################################### SEP1 & SEP2 ###############################################
###############################################################################################
  tar_target(MergeGOPlot, mergePlot(GOPlot.SEP1,GOPlot,NROW=1,LABELS=c("A", "B"))),           # Script 11
  tar_target(MergeSumPlot, mergePlot(SumPlot.SEP1, SumPlot, NROW=2, LABELS=c("A", "B"))),     # Comparing ORF content from SEP1 & 2 assemblies
  tar_target(MergeGOPlotExport, PlotExport("results/Annotation/figures/GOPlot.SEP1.SEP2.jpg", MergeGOPlot, W=10, H=7, U="in")),
  tar_target(MergeSumPlotExport, PlotExport("results/Annotation/figures/Sum.SEP1.SEP2.jpg", MergeSumPlot)),
  tar_target(file12, "data/annotation/RBH_pairs.tsv"),                                        #
  tar_target(file13, "data/annotation/SEP1_all_ids_clean.txt"),                              #
  tar_target(file14, "data/annotation/SEP2_all_ids_clean.txt"),                              #
  tar_target(Venn, displayVenn(file12,file13,file14)),                                        #
  tar_target(VennExport, PlotExport("results/Annotation/figures/Venn.SEP1.SEP2.jpg", Venn)),  #
  tar_target(file15, "data/annotation/SEP1_specific_nohit.txt"),
  tar_target(file16, "data/annotation/SEP2_specific_nohit.txt"),
  tar_target(SEP1.spec, displaySpecific(file12,file13,file15)),
  tar_target(SEP2.spec, displaySpecific(file12,file14,file16, exp="SEP2")),
###############################################################################################
##################### GO enrichment analysis of specific transcripts ###################
######################################################################################################
  tar_target(GOforMWU.SEP1, GOMWU(file13, file15, FullAnnot.SEP1)),                                  #
  tar_target(GENEforMWU.SEP1, GENEMWU(file13, file15, GOforMWU.SEP1)),                               # Standard GO enrichment (Fisher's exact test) not significiant...
  tar_target(GOTable.SEP1, outputGO(GOforMWU.SEP1, "R/Annotation/GOMWU/GeneToGO.SEP1.tab")),         #
  tar_target(GENETable.SEP1, ExportGENE(GENEforMWU.SEP1, "R/Annotation/GOMWU/GeneToValue.SEP1.csv")),#
######################################################################################################
  tar_target(GOforMWU.SEP2, GOMWU(file14, file16, FullAnnot)),                                       #
  tar_target(GENEforMWU.SEP2, GENEMWU(file14, file16, GOforMWU.SEP2)),                               # Standard GO enrichment (Fisher's exact test) not significiant...
  tar_target(GOTable.SEP2, outputGO(GOforMWU.SEP2, "R/Annotation/GOMWU/GeneToGO.SEP2.tab")),         # 
  tar_target(GENETable.SEP2, ExportGENE(GENEforMWU.SEP2, "R/Annotation/GOMWU/GeneToValue.SEP2.csv")),#
######################################################################################################
#       ...so let's vizualise the main GO terms in each "specific" set and find those that are unique to each set.
  tar_target(go_ont, ontology("R/Annotation/GOMWU/go.obo")),
  tar_target(go_namespace, namespace("R/Annotation/GOMWU/go.obo")),
  tar_target(GO.SEP1, ListGOs(ANNOT=FullAnnot.SEP1, speFile=file15, NAMESPACE=go_namespace, ONT="biological_process")),
  tar_target(GO.lvl.SEP1, getGOlevel(GO.SEP1, go_ont)),
  tar_target(macroMap.SEP1, macroMap(GO.SEP1, go_ont, TARGET1=10, TARGET2=3)),
  tar_target(PlotMacroMap.SEP1, plotMacro(macroMap.SEP1)),
################################################################################################################################################################
  tar_target(GO.SEP1.spe, ListGOs(ANNOT=FullAnnot.SEP1, speFile=file15, ANNOT2=FullAnnot, specific = TRUE, NAMESPACE=go_namespace, ONT="biological_process")), # Finaly contains same information as the previous one.
  tar_target(GO.lvl.SEP1.spe, getGOlevel(GO.SEP1.spe, go_ont)),
  tar_target(macroMap.SEP1.spe, macroMap(GO.SEP1.spe, go_ont, TARGET1=6, TARGET2=3)),
  tar_target(PlotMacroMap.SEP1.spe, plotMacro(macroMap.SEP1.spe)),
################################################################################################################################################################
  tar_target(GO.SEP2.spe, ListGOs(ANNOT=FullAnnot, speFile=file15, ANNOT2=FullAnnot.SEP1, specific = TRUE, NAMESPACE=go_namespace, ONT="biological_process")), # Finaly contains same information as the previous one.
  tar_target(GO.lvl.SEP2.spe, getGOlevel(GO.SEP2.spe, go_ont)),
  tar_target(macroMap.SEP2.spe, macroMap(GO.SEP2.spe, go_ont, TARGET1=6, TARGET2=3)),
  tar_target(PlotMacroMap.SEP2.spe, plotMacro(macroMap.SEP2.spe)),
################################################################################################################################################################
  tar_target(GO.SEP2, ListGOs(ANNOT=FullAnnot, speFile=file16, NAMESPACE=go_namespace, ONT="biological_process")),
  tar_target(GO.lvl.SEP2, getGOlevel(GO.SEP2, go_ont)),
  tar_target(macroMap.SEP2, macroMap(GO.SEP2, go_ont, TARGET1=6, TARGET2=3)),
  tar_target(PlotMacroMap.SEP2, plotMacro(macroMap.SEP2)),
################################################################################################################################################################
  tar_target(ResumeComparison, cowPlot(Venn, SEP1.spec, SEP2.spec, PlotMacroMap.SEP1.spe, PlotMacroMap.SEP2.spe)),
  tar_target(ExportResume, PlotExport("results/annotation/figures/ResumeComparison.jpg", ResumeComparison, W = 25, H = 12, U="in")),
###################################################################################################################################################
#######################################################################################
  tar_render(report, path='Report/RNAsep2_Annotation_Report.Rmd'),                    # Building a quick report
#######################################################################################
####################################æ###################################################
  tar_render(article, path='Report/Transcriptome_Announcement.Rmd'))

#############################################

# Pipeline interaction commands

############################################

# Sys.setenv(TAR_PROJECT="Annotation")

# tar_manifest(fields=command)

# tar_visnetwork(physics=TRUE)

# tar_make(article)

# tar_read()