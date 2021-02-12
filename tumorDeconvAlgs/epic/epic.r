#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
if (!is.null(args[1])) {
    df <- read.csv(args[1], sep = "\t", row.names = 1)
    if (max(df, na.rm = TRUE) < 50) {
        df <- 2^df
    }
} else {
    stop("No expression matrix provided!")
}

library(EPIC)

if (length(args) > 1) {
    ref <- read.csv(args[2], sep = "\t", row.names = 1) ### Need to change later
    cellTypeNames <- colnames(ref)
    markerGenes <- c()
    for (s in colnames(ref)) {
        tempMarkers <- rownames(ref[ref[,s] > quantile(ref[,s], prob=0.75),])
        if (length(args) > 2) {
            if (tolower(args[3]) == "pairwise") {
                tempTb = 2 * ref[,cellTypeNames[cellTypeNames != s]] - ref[,s]
                tempMarkers <- tempMarkers[tempMarkers %in% rownames(ref[rowSums(tempTb < 0) == (length(cellTypeNames) - 1), ])]
            } else {
                stop("The signature matrix processing option is not provided correctly!")
            }
        } else {
            tempMarkers <- tempMarkers[tempMarkers %in% rownames(ref)[ref[,s] > 2 * rowMeans(ref)]]
        }
        genesTemp <- tempMarkers
        markerGenes <- c(markerGenes, genesTemp)
        # genesNull <- rownames(ref)[!(rownames(ref) %in% genesTemp)]
        # ref[genesNull, s] <- 0.0
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
