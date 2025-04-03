###########################################################################
#				RNAsep PROJECT				###
###########################################################################

Testing for transcriptomic effects of Hg x pCO2 on Sepia officinalis juveniles (head tissues).

This project is divided in two part : (i) *de novo* transcriptome assembly and annotation ; (ii) differential expression analysis.

The assembly and annotation were performed on the IFB-Core cluster.

The differential expression analysis was performed using R language. 

#############################################################
## A great attention is paid to the workflow reproducibility.

Therefore, all the bioinformatics tools are given above with the version used and the folders and scripts are numbered based on their execution order.
Regarding R workflow, the 'renv' package was used to ensure the portability of the project library.
In addition, the 'target' package was used for workflow management, so it is fully reproducible.
To easily reproduce this R project, one just need to:
| 	1- download the whole R_analysis folder on its own machine;
|	2- download the appropriate data in a folder called "data" located at the root of the project
|	3- charging the project library with 'renv::restore()';
|	4- run the *_targets.R scripts

<img src="Workflow.png" width="600"/>

#######################################################
## Bioinformatic Tools and versions for data processing

### 1. Quality check:

FASTQC_v0.12.1	; MULTIQC_v1.14

### 2. Trimming:

Trimmomatic_v0.39

### 3. Assembling:

bowtie_v2.5.1	; samtools_v1.14	; Jellyfish_v2.3.0

Salmon_v1.10.1	; Python_v3.11.1	; Trinity_v2.15.1

### 3a. Assembly Thinning (to remove redundancy):

cd-hit_v4.8.1

### 4. Assembly quality assessment (https://github.com/trinityrnaseq/trinityrnaseq/wiki):

-> ContigsN50: Trinity_v2.15.1

-> E90N50: Kallisto_v0.46.2	; Trinity_v2.15.1

-> Completness: BUSCO_v5.5.0

-> Full-length transcript analysis: BLAST_v2.16.0

-> Read content: STAR_v2.7.11a

-> Various statistics: TransRate_v1.0.3

### 5. Assembly annotation

TransDecoder_V5.7.0	; BLAST_v2.16.0 

eggnog-mapper_v2.1.12	; Reactome : https://reactome.org/PathwayBrowser/#TOOL=AT

### 6. Alignment

STAR_v2.7.11a




