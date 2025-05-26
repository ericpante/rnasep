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
  packages = c("dplyr","tidyr", "readxl", "readr", "ggplot2", "wesanderson", "data.table", "VennDiagram", "cowplot"))

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
tar_source("R/Annotation/12-MergePlot.R")


# Replace the target list below with your own:
list(
#########################################################################################  
##################################### RNA SEP2 ##########################################  
#########################################################################################  
  tar_target(file1, "data/annotation/rnasep2_Trinity95.blastx.outfmt6"),                #
  tar_target(blastx, load_blast(file1)),                                                # Scripts 1 & 2
  tar_target(ePropX, Prep_evalue(blastx)),                                              # Loading, processing & plotting blastx e-values
  tar_target(ePlotX, PlotEvalue(ePropX)),                                               #
  tar_target(PlotX, PlotExport("results/Annotation/figures/BlastX.eValue.png",ePlotX)), #
#########################################################################################
  tar_target(file2, "data/annotation/rnasep2_Trinity95.blastp.outfmt6"),                #
  tar_target(blastp, load_blast(file2)),                                                # Scripts 1 & 2
  tar_target(ePropP, Prep_evalue(blastp)),                                              # Loading, processing & plotting blastp e-values
  tar_target(ePlotP, PlotEvalue(ePropP)),                                               #
  tar_target(PlotP, PlotExport("results/Annotation/figures/BlastP.eValue.png",ePlotP)), #
#########################################################################################
  tar_target(X, Tidy_blast(blastx, blastp, filter_on=TRUE)),                            # Script 3
  tar_target(P, Tidy_blast(blastp, blastx, filter_on=FALSE)),                           # Tidying & merging blastx and blastp annotations 
  tar_target(BlastAnnot, Blast_annot(X,P)),                                             #
#########################################################################################
#########################################################################################
  tar_target(file3,"data/annotation/rnasep2_Trinity95.emapper.annotations.xlsx"),       #
  tar_target(eggnog, load_eggnog(file3)),                                               # Script 4
  tar_target(file4,"data/annotation/rnasep2_Trinity95.nt.emapper.annotations.xlsx"),    # Loading, tidying & merging EggNOG and EggNOG.nt outputs
  tar_target(eggnog.nt, load_eggnog(file4)),                                            #
  tar_target(EG.nt, Tidy_eggnog(eggnog.nt, eggnog, filter_on=TRUE)),                    #
  tar_target(EG, Tidy_eggnog(eggnog, eggnog.nt, filter_on=FALSE)),                      # 
  tar_target(EggnogAnnot, Eggnog_annot(EG.nt, EG)),                                     #
#########################################################################################
#########################################################################################################################
  tar_target(FullAnnot, Full_annot(BlastAnnot,EggnogAnnot)),                                                            # Scripts 5 & 6
  tar_target(FinalAnnot, FileExport(FullAnnot, "results/Annotation/files/rnasep2_Trinity95_FunctionalAnnotation.csv")), # Building & exporting full annotation file
#########################################################################################################################
###################################################################################################
  tar_target(file5, "data/annotation/REACTOME.csv"),                                              #
  tar_target(Reactome, load_reac(file5)),                                                         # Scripts 2 & 7
  tar_target(ReactomeTidy, tidy_reac(Reactome)),                                                  # Loading, tidying & plotting REACTOME results
  tar_target(PlotReactome, PlotReac(ReactomeTidy)),                                               #
  tar_target(ExportReactome, PlotExport("results/Annotation/figures/Reactome.png",PlotReactome)), #
###################################################################################################
#########################################################################################################
  tar_target(file6, "configFiles/go.obo.rtf"),                                                          #
  tar_target(GOterms, extract_GO_terms_and_namespaces(file6)),                                          # Script 8 & 9
  tar_target(GO_summary, summarizeGO(EggnogAnnot, GOterms)),                                            # Building and plotting main GO terms of each Namespace
  tar_target(GOPlot, PlotGO(GO_summary,"biological_process","molecular_function","cellular_component")),#
  tar_target(ExportGO, PlotExport("results/Annotation/figures/MainGOterms.png", GOPlot)),               #
#########################################################################################################
#########################################################################################################
  tar_target(SumPlot, SumAnnotation(FullAnnot)),                                                        # Scripts 10 & 2
  tar_target(ExportSum, PlotExport("results/Annotation/figures/SumAnnotation.png", SumPlot)),           # Calculating & plotting the percentage of transsccripts that are annotated
#########################################################################################################
#########################################################################################################
######################################################################################################### 
##################################### RNA SEP1 #########################################################
########################################################################################################
########################################################################################################
  tar_target(file7, "data/annotation/rnasep1_Trinity95.blastx.outfmt6"),                               #
  tar_target(blastx.SEP1, load_blast(file7)),                                                          # Scripts 1 & 2
  tar_target(ePropX.SEP1, Prep_evalue(blastx.SEP1)),                                                   # Loading, processing & plotting blastx e-values SEP1
  tar_target(ePlotX.SEP1, PlotEvalue(ePropX.SEP1)),                                                    #
  tar_target(PlotX.SEP1, PlotExport("results/Annotation/figures/BlastX.eValue.SEP1.png",ePlotX.SEP1)), #
########################################################################################################
  tar_target(file8, "data/annotation/rnasep1_Trinity95.blastp.outfmt6"),                               #
  tar_target(blastp.SEP1, load_blast(file8)),                                                          # Scripts 1 & 2
  tar_target(ePropP.SEP1, Prep_evalue(blastp.SEP1)),                                                   # Loading, processing & plotting blastp e-values SEP1
  tar_target(ePlotP.SEP1, PlotEvalue(ePropP.SEP1)),                                                    #
  tar_target(PlotP.SEP1, PlotExport("results/Annotation/figures/BlastP.eValue.SEP1.png",ePlotP.SEP1)), #
########################################################################################################
  tar_target(X.SEP1, Tidy_blast(blastx.SEP1, blastp.SEP1, filter_on=TRUE)),                            # Script 3
  tar_target(P.SEP1, Tidy_blast(blastp.SEP1, blastx.SEP1, filter_on=FALSE)),                           # Tidying & merging blastx and blastp annotations SEP1
  tar_target(BlastAnnot.SEP1, Blast_annot(X.SEP1,P.SEP1)),                                             #
########################################################################################################
#########################################################################################
  tar_target(file9,"data/annotation/rnasep1_Trinity95.emapper.annotations.xlsx"),       #
  tar_target(eggnog.SEP1, load_eggnog(file9)),                                            
  tar_target(file10,"data/annotation/rnasep1_Trinity95.nt.emapper.annotations.xlsx"),   # 
  tar_target(eggnog.nt.SEP1, load_eggnog(file10)),                                      # Script 4
  tar_target(EG.nt.SEP1, Tidy_eggnog(eggnog.nt.SEP1, eggnog.SEP1, filter_on=TRUE)),     # Loading, tidying & merging EggNOG and EggNOG.nt outputs SEP1
  tar_target(EG.SEP1, Tidy_eggnog(eggnog.SEP1, eggnog.nt.SEP1, filter_on=FALSE)),       # 
  tar_target(EggnogAnnot.SEP1, Eggnog_annot(EG.nt.SEP1, EG.SEP1)),                      #
#########################################################################################
#################################################################################################################################
  tar_target(FullAnnot.SEP1, Full_annot(BlastAnnot.SEP1,EggnogAnnot.SEP1)),                                                       # Scripts 5 & 6
  tar_target(FinalAnnot.SEP1, FileExport(FullAnnot.SEP1, "results/Annotation/files/rnasep1_Trinity95_FunctionalAnnotation.csv")), # Building & exporting full annotation file SEP1
#################################################################################################################################
#################################################################################################################
  tar_target(file11, "data/annotation/REACTOME.SEP1.csv"),                                                      #
  tar_target(Reactome.SEP1, load_reac(file11)),                                                                 # Scripts 2 & 7
  tar_target(ReactomeTidy.SEP1, tidy_reac(Reactome.SEP1)),                                                      # Loading, tidying & plotting REACTOME results SEP1
  tar_target(PlotReactome.SEP1, PlotReac(ReactomeTidy.SEP1)),                                                   #
  tar_target(ExportReactome.SEP1, PlotExport("results/Annotation/figures/Reactome.SEP1.png",PlotReactome.SEP1)),#
#################################################################################################################
#####################################################################################################################
  tar_target(GO_summary.SEP1, summarizeGO(EggnogAnnot.SEP1, GOterms)),                                              # Script 8 & 9
  tar_target(GOPlot.SEP1, PlotGO(GO_summary.SEP1,"biological_process","molecular_function","cellular_component")),  # Building and plotting main GO terms of each Namespace SEP1
  tar_target(ExportGO.SEP1, PlotExport("results/Annotation/figures/MainGOterms.SEP1.png", GOPlot.SEP1)),            #
#####################################################################################################################
#########################################################################################################
  tar_target(SumPlot.SEP1, SumAnnotation(FullAnnot.SEP1)),                                              # Scripts 10 & 2
  tar_target(ExportSum.SEP1, PlotExport("results/Annotation/figures/SumAnnotation.SEP1.png", SumPlot.SEP1)), # Calculating & plotting the percentage of transsccripts that are annotated
#########################################################################################################
#########################################################################################################
###############################################################################################
################################### SEP1 & SEP2 ###############################################
###############################################################################################
  tar_target(MergeGOPlot, mergePlot(GOPlot.SEP1,GOPlot,NROW=1,LABELS=c("A", "B"))),           #
  tar_target(MergeSumPlot, mergePlot(SumPlot.SEP1, SumPlot, NROW=2, LABELS=c("A", "B"))),     #
  tar_target(file12, "data/annotation/Trinity_rnasep1.Trinity95.fasta.transdecoder.cds"),     #
  tar_target(file13, "data/annotation/Trinity_rnasep2.Trinity95.fasta.transdecoder.cds"),     #
  tar_target(file14, "data/annotation/SEP1.SEP2.blastn.outfmt6"),                             #
  tar_target(VennData, BuildVennData(file12,file13,file14)),                                  #
  tar_target(Venn, displayVenn(VennData,                                                      #
                               category.names=c("One month old", "Newly hatched"),            #
                               lwd=2.1,                                                         #
                               lty=4,                                                         # Script 11
                               margin=0.11,
                               fill=wes_palette(n=2, name="GrandBudapest2"),                  # Comparing ORF content from SEP1 & 2 assemblies
                               cex=2.5,                                                        #
                               fontface="italic",                                             #
                               cat.cex=2,                                                    #
                               cat.fontface="bold",                                           #
                               cat.pos=c(-30,30),
                               cat.default.pos="outer",                                       #
                               cat.dist=c(0.08, 0.08))),                                      #
  tar_target(VennExport, PlotExport("results/Annotation/figures/Venn.SEP1.SEP3.png", Venn)),  #
###############################################################################################
#######################################################################################
  tar_render(report, path='Report/RNAsep2_Annotation_Report.Rmd'),                    # Building a quick report
#######################################################################################
#######################################################################################
  tar_render(article, path='Report/Transcriptome_Announcement.Rmd')
  )

#############################################

# Pipeline interaction commands

############################################

# Sys.setenv(TAR_PROJECT="Annotation")

# tar_manifest(fields=command)

# tar_visnetwork(physics=TRUE)

# tar_make(Venn)
# tar_make(VennExport)

# tar_read()