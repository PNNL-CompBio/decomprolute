#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
if (!is.null(args[1])) {
    df <- read.csv(args[1], sep = "\t", row.names = 1)
} else {
    stop("No expression matrix provided!")
}

library(EPIC)

if (!is.null(args[2])) {
    ref <- read.csv(args[2], sep = "\t", row.names = 1) ### Need to change later
    markerGenes <- c()
    for (s in colnames(ref)) {
        genesTemp <- rownames(ref[ref[,s] > quantile(ref[,s], prob=0.90),])
        markerGenes <- c(markerGenes, genesTemp)
        genesNull <- rownames(ref[ref[,s] <= quantile(ref[,s], prob=0.90),])
        ref[genesNull, s] <- 0.0
    }
    markerGenes <- unique(markerGenes)
    
    epicRef <- list()
    epicRef$refProfiles <- ref
    epicRef$sigGenes <- markerGenes
    
    xc <- EPIC(bulk = df, reference = epicRef)
} else {
    xc <- EPIC(bulk = df)
}

results <- xc$cellFractions
results <- results[,colnames(results) != "otherCells"]

write.table(t(results), file = "deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
