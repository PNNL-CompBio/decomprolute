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

library(matrixStats)
library(xCell)

if (length(args) > 1) {
    ref <- read.csv(args[2], sep = "\t", row.names = 1) ### Need to change later
    ref <- as.data.frame(ref[intersect(rownames(ref), rownames(df)),])
    cellTypeNames <- colnames(ref)
    marker <- list()
    taggedNames <- c()
    for (i in seq(dim(ref)[2])) {
        s = cellTypeNames[i]
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
            # tempMarkers <- rownames(ref[ref[,s] > quantile(ref[,s], prob=0.5),])
            deOverMedians <- (ref[tempMarkers,s] - rowMedians(as.matrix(ref[tempMarkers,])))/rowMedians(as.matrix(ref[tempMarkers,]))
            markers <- tempMarkers[deOverMedians > quantile(deOverMedians, prob=0.9)]
        }
        marker[[i]] <- markers
        taggedNames <- c(taggedNames, paste0(colnames(ref)[i], "%", cellTypeNames[i], toString(i), "%", cellTypeNames[i], toString(i), ".txt"))
    }
    
    names(marker) <- taggedNames#paste0(colnames(ref), "%tag0%tag1")
    
    spill <- list()
    spill[["K"]] <- matrix(1/length(cellTypeNames), nrow = length(cellTypeNames), ncol = length(cellTypeNames), dimnames = list(cellTypeNames, cellTypeNames))
    spill[["fv"]] <- as.data.frame(matrix(1, nrow = length(cellTypeNames), ncol = 3, dimnames = list(cellTypeNames, c("V1", "V2", "V3"))))
    
    xc <- xCellAnalysis(df, file.name = "deconvoluted.tsv", signatures = marker, genes = rownames(df), cell.types.use = cellTypeNames, spill = spill, scale = FALSE, parallel.sz = 1)
} else {
    xc <- xCellAnalysis(df, file.name = "deconvoluted.tsv")
}

#write.table(xc, file = "deconvoluted-pvalue.tsv", quote = FALSE, col.names = NA, sep = "\t")
