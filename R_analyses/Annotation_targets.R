rm(list=ls())

# Load packages required to define the pipeline:
library(targets)
library(visNetwork)

# Set target options:
tar_option_set(
  packages = c("dplyr","tidyr", "readxl", "readr", "ggplot2"))

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/Annotation/01-LoadBlast.R")
tar_source("R/Annotation/02-Prep_evalue.R")
tar_source("R/Annotation/03-Plot_evalue.R")
tar_source("R/Annotation/04-PlotExport.R")
tar_source("R/Annotation/05-Blast_tidy.R")
tar_source("R/Annotation/06-Blast_merge.R")
tar_source("R/Annotation/07-eggnog_tidy.R")
tar_source("R/Annotation/08-eggnog_merge.R")
tar_source("R/Annotation/09-Full_annot.R")
tar_source("R/Annotation/10-ExportFile.R")


# Replace the target list below with your own:
list(
  tar_target(file1, "data/annotation/rnasep2_Trinity95.blastx.outfmt6"),
  tar_target(blastx, load_blast(file1)),
  tar_target(ePropX, Prep_evalue(blastx)),
  tar_target(ePlotX, PlotEvalue(ePropX)),
  tar_target(PlotX, PlotExport("results/Annotation/figures/BlastX.eValue.png",ePlotX)),
  tar_target(file2, "data/annotation/rnasep2_Trinity95.blastp.outfmt6"),
  tar_target(blastp, load_blast(file2)),
  tar_target(ePropP, Prep_evalue(blastp)),
  tar_target(ePlotP, PlotEvalue(ePropP)),
  tar_target(PlotP, PlotExport("results/Annotation/figures/BlastP.eValue.png",ePlotP)),
  tar_target(X, Tidy_blast(blastx)),
  tar_target(P, Tidy_blast(blastp)),
  tar_target(BlastAnnot, Blast_annot(X,P)),
  tar_target(file3,"data/annotation/rnasep2_Trinity95.emapper.annotations.xlsx"),
  tar_target(eggnog, load_eggnog(file3)),
  tar_target(EG, Tidy_eggnog(eggnog)),
  tar_target(file4,"data/annotation/rnasep2_Trinity95.nt.emapper.annotations.xlsx"),
  tar_target(eggnog.nt, load_eggnog(file4)),
  tar_target(EG.nt, Tidy_eggnog(eggnog.nt)),
  tar_target(EggnogAnnot, Eggnog_annot(EG.nt, EG)),
  tar_target(FullAnnot, Full_annot(BlastAnnot,EggnogAnnot)),
  tar_target(FinalAnnot, FileExport(FullAnnot, "results/Annotation/files/rnasep2_Trinity95_FunctionalAnnotation.csv"))
  )

#############################################

# Pipeline interaction commands

############################################

# Sys.setenv(TAR_PROJECT="Annotation")

# tar_manifest(fields=command)

# tar_visnetwork(physics=TRUE)

# tar_make()

# tar_read(FullAnnot)
