#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
if (!is.null(args[1])) {
    df <- read.csv(args[1], sep = "\t", row.names = 1)
} else {
    stop("No expression matrix provided!")
}

library("xCell")

if (!is.null(args[2])) {
    ref <- read.csv(args[2], sep = "\t", row.names = 1) ### Need to change later
    marker <- list()
    for (s in colnames(ref)) marker[[s]]<-rownames(ref[ref[,s] > quantile(ref[,s], prob=0.90),])
    
    xc <- xCellAnalysis(df, file.name = "deconvoluted.tsv", signatures = marker)
} else {
    xc <- xCellAnalysis(df, file.name = "deconvoluted.tsv")
}

write.table(xc, file = "deconvoluted-pvalue.tsv", quote = FALSE, col.names = NA, sep = "\t")
