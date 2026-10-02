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
col_data <- read.delim(file.path(root, 'data', 'sample_metadata.csv'))
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


dds <- DESeqDataSetFromTximport(

)


dds$group <- relevel(dds$group, ref = "warm")

# add row ranges
row_data <- row_data[rownames(dds),]
rownames(dds) <- row_data$txi

# save for local analysis
save(dds, file = file.path(root, 'results', 'DESeqDataSet.RData'))






### below from other class ###

## Count data from salmon

# build file paths to the quant.sf files
files <- file.path(root, "results", paste0(col_data$RunAccession, "_quant"), "quant.sf")
names(files) <- col_data$RunAccession

# Verify all files exist before proceeding
stopifnot(all(file.exists(files)))


# if want to analyze 
txi <- tximport(files, type = "salmon", txOut = TRUE)

# validation
stopifnot(all.equal(colnames(txi$abundance), col_data$RunAccession))

# create our DESeq object
dds <- DESeqDataSetFromTximport(
  txi = txi,
  colData = col_data,
  design = ~ Sample
)

dds$Sample <- relevel(dds$Sample, ref = "WT")

# add row ranges
rowranges <- rowranges[rownames(dds)]
rowRanges(dds) <- rowranges


