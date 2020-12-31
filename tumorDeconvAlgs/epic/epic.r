#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
file0 <- args[1]
ref <- NULL
if (!is.null(args[2])) {
    file1 <- args[1]
    ref <- read.csv(file1, sep = "\t", row.names = 1) ### Need to change later
}

library(EPIC)

df <- read.csv(file0, sep = "\t", row.names = 1)
xc <- EPIC(bulk = df, reference = ref)
write.table(xc, file = "deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
