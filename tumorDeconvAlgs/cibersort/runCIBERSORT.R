#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
if (!is.null(args[1])) {
  df <- read.csv(args[1], sep = "\t", row.names = 1)
} else {
  stop("No expression matrix provided!")
}

if (!is.null(args[2])) {
  ref <- read.csv(args[2], sep = "\t", row.names = 1) ### Need to change later
  cs <- CIBERSORT(df, file.name = "deconvoluted.tsv", signatures = marker)
} else {
  cs <- CIBERSORT(df, file.name = "deconvoluted.tsv")
}

write.table(xc, file = "deconvoluted-pvalue.tsv", quote = FALSE, col.names = NA, sep = "\t")