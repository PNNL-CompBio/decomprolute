#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
if (!is.null(args[1])) {
    df <- read.csv(args[1], sep = "\t", row.names = 1)
} else {
    stop("No expression matrix provided!")
}

library(MCPcounter)

if (!is.null(args[2])) {
    ref <- read.csv(args[2], sep = "\t", row.names = 1) ### Need to change later
    markerGenes <- c()
    cellTypes <- c()
    for (s in colnames(ref)) {
        genesTemp <- rownames(ref[ref[,s] > quantile(ref[,s], prob=0.90),])
        markerGenes <- c(markerGenes, genesTemp)
        cellTypes <- c(cellTypes, rep(s, length(genesTemp)))
    }
    sigList <- data.frame("HUGO symbols" = markerGenes, "Cell population" = cellTypes)
    colnames(sigList) <- c("HUGO symbols", "Cell population")
    
    mcp <- MCPcounter.estimate(df, featuresType = "HUGO_symbols", genes = sigList)
} else {
    mcp <- MCPcounter.estimate(df, featuresType = "HUGO_symbols")
}

write.table(mcp, file="deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
