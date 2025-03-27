rm(list=ls())

# Load packages required to define the pipeline:
library(targets)
library(visNetwork)

# Set target options:
tar_option_set(
  packages = c("dplyr","tidyr"))

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/Annotation/Blastx_tidy.R")
tar_source("R/Annotation/Blastp_tidy.R")
tar_source("R/Annotation/Blast_merge.R")

# Replace the target list below with your own:
list(
  tar_target(file1, "data/annotation/rnasep2_Trinity95.blastx.outfmt6"),
  tar_target(blastx, load_blastx(file1)),
  tar_target(X, Tidy_blastx(blastx)),
  tar_target(file2, "data/annotation/rnasep2_Trinity95.blastp.outfmt6"),
  tar_target(blastp, load_blastp(file2)),
  tar_target(P, Tidy_blastp(blastp)),
  tar_target(BlastAnnot,Merge_blast(X,P))
  )

#############################################

# Pipeline interaction commands

############################################

# Sys.setenv(TAR_PROJECT="Annotation")

# tar_manifest(fields=command)

# tar_visnetwork()

# tar_make()

# tar_read()