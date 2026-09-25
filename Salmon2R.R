## Setup/dependancies
# import salmon quant output into BioConductor format
library(tximport)
library(SummarizedExperiment)
library(DESeq2)
library(dplyr)
library(withr)

# root to make more portable
root <- here::here()


## Column/Sample metadata

# get the experimental metadata (colData)
col_data <- read.delim(file.path(root, 'data', 'ERP004763_sample_mapping.tsv'))
rownames(col_data) <- col_data$SRAid


## Row/Transcript metadata

refloc <- file.path(root, 'ref', 'Octous_bimaculoides_2_ASM119413v2_rna.fna')
fa_lines <- readLines(refloc)
headers <- fa_lines[grep("^>", fa_lines)] |>
  str_replace("PREDICTED: ", "")

row_data <- data.frame(txid = sub("^>([^ ]+).*", "\\1", headers),
                       species = sub("^\\S+\\s+(\\S+\\s+\\S+).*", "\\1", headers),
                       details = sub("^(?:[^ ]+ +){3}(.+) \\(.*", "\\2", headers),
                       geneid = sub(".*?\\((.*?)\\).*", "\\1", headers),
                       type = sub(".*, (.*)$", "\\1", headers))

rownames(row_data) <- row_data$txid

## Counts


