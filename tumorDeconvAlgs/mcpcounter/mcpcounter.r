#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
if (!is.null(args[1])) {
    df <- read.csv(args[1], sep = "\t", row.names = 1,check.names=FALSE)
    df[df == 0] <- NA
    if (max(df, na.rm = TRUE) < 50) {
        df <- 2^df
    }
    # df <- df[rowSums(is.na(df)) != ncol(df), ]
    df[is.na(df)] <- 0
} else {
    stop("No expression matrix provided!")
}

library(matrixStats)
library(MCPcounter)

if (length(args) > 1) {
    ref <- read.csv(args[2], sep = "\t", row.names = 1, check.names=FALSE, header=T) ### Need to change later
    cellTypeNames <- colnames(ref)
   # print(cellTypeNames)
    markerGenes <- c()
    cellTypes <- c()
    for (s in colnames(ref)) {
        tempMarkers <- rownames(ref[ref[,s] > quantile(ref[,s], prob=0.75),])
        markers <- c()
        if (length(args) > 2) {
            if (tolower(args[3]) == "pairwise") {
                tempTb = 2 * ref[,cellTypeNames[cellTypeNames != s]] - ref[,s]
                markers <- tempMarkers[tempMarkers %in% rownames(ref[rowSums(tempTb < 0) == (length(cellTypeNames) - 1), ])]
            } else {
                markers <- tempMarkers[tempMarkers %in% rownames(ref)[ref[,s] > 2 * rowMedians(as.matrix(ref))]]
            }
        } else {
            markers <- tempMarkers[tempMarkers %in% rownames(ref)[ref[,s] > 2 * rowMedians(as.matrix(ref))]]
        }
        if (length(markers) == 0) {
            tempMarkers <- rownames(ref[ref[,s] > quantile(ref[,s], prob=0.5),])
            deOverMedians <- (ref[tempMarkers,s] - rowMedians(as.matrix(ref[tempMarkers,])))/rowMedians(as.matrix(ref[tempMarkers,]))
            markers <- tempMarkers[deOverMedians > quantile(deOverMedians, prob=0.9)]
        }
        genesTemp <- markers
        markerGenes <- c(markerGenes, genesTemp)
        cellTypes <- c(cellTypes, rep(s, length(genesTemp)))
    }
    sigList <- data.frame("HUGO symbols" = markerGenes, "Cell population" = cellTypes)
    colnames(sigList) <- c("HUGO symbols", "Cell population")
    tryCatch(
        expr = {
            mcp <- MCPcounter.estimate(df, featuresType = "HUGO_symbols", genes = sigList)
            write.table(mcp, file="deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
        },
        error = function(e){
            # (Optional)
            # Do this if an error is caught...
            print(e)
            X <- read.csv(args[2], sep = "\t", row.names = 1)
            Y <- read.csv(args[1], sep = "\t")
            mcp <- matrix(0, ncol = length(colnames(Y)) - 1, nrow = length(colnames(X)), dimnames = list(colnames(X), colnames(Y)[2:length(colnames(Y))]))
            write.table(mcp, file="deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
        }
    )
} else {
    mcp <- MCPcounter.estimate(df, featuresType = "HUGO_symbols")
    write.table(mcp, file="deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
}
