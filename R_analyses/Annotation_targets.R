###############################################################################

# Here is the 'targets' script managing the "Annotation" R workflow.

###############################################################################

rm(list=ls())

# Load packages required to define the pipeline:
library(targets)
library(visNetwork)

# Set target options:
tar_option_set(
  packages = c("dplyr","tidyr", "readxl", "readr", "ggplot2", "wesanderson", "data.table"))

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


# Replace the target list below with your own:
list(
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
  tar_target(X, Tidy_blast(blastx)),                                                    # Script 3
  tar_target(P, Tidy_blast(blastp)),                                                    # Tidying & merging blastx and blastp annotations 
  tar_target(BlastAnnot, Blast_annot(X,P)),                                             #
#########################################################################################
#########################################################################################
  tar_target(file3,"data/annotation/rnasep2_Trinity95.emapper.annotations.xlsx"),       #
  tar_target(eggnog, load_eggnog(file3)),                                               #
  tar_target(EG, Tidy_eggnog(eggnog)),                                                  # Script 4
  tar_target(file4,"data/annotation/rnasep2_Trinity95.nt.emapper.annotations.xlsx"),    # Loading, tidying & merging EggNOG and EggNOG.nt outputs
  tar_target(eggnog.nt, load_eggnog(file4)),                                            #
  tar_target(EG.nt, Tidy_eggnog(eggnog.nt)),                                            #
  tar_target(EggnogAnnot, Eggnog_annot(EG.nt, EG)),                                     #
#########################################################################################
#########################################################################################################################
  tar_target(FullAnnot, Full_annot(BlastAnnot,EggnogAnnot)),                                                            # Script 5
  tar_target(FinalAnnot, FileExport(FullAnnot, "results/Annotation/files/rnasep2_Trinity95_FunctionalAnnotation.csv")), # Building & exporting full annotation file
#########################################################################################################################
###################################################################################################
  tar_target(file5, "data/annotation/REACTOME.csv"),                                              #
  tar_target(Reactome, load_reac(file5)),                                                         # Script 7
  tar_target(ReactomeTidy, tidy_reac(Reactome)),                                                  # Loading, tidying & plotting REACTOME results
  tar_target(PlotReactome, PlotReac(ReactomeTidy)),                                               #
  tar_target(ExportReactome, PlotExport("results/Annotation/figures/Reactome.png",PlotReactome)), #
###################################################################################################
#########################################################################################################
  tar_target(file6, "configFiles/go.obo.rtf"),                                                          #
  tar_target(GOterms, extract_GO_terms_and_namespaces(file6)),                                          #
  tar_target(GO_summary, summarizeGO(EggnogAnnot, GOterms)),                                            # Building and plotting main GO terms of each Namespace
  tar_target(GOPlot, PlotGO(GO_summary,"biological_process","molecular_function","cellular_component")),#
  tar_target(ExportGO, PlotExport("results/Annotation/figures/MainGOterms.png", GOPlot))                #
#########################################################################################################
#########################################################################################################
  )

#############################################

# Pipeline interaction commands

############################################

# Sys.setenv(TAR_PROJECT="Annotation")

# tar_manifest(fields=command)

# tar_visnetwork(physics=TRUE)

# tar_make()

# tar_read(FullAnnot)
