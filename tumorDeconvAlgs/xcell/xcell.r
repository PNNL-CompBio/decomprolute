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
    ref <- as.data.frame(ref[intersect(rownames(ref), rownames(df)),])
    cellTypeNames <- colnames(ref)
    marker <- list()
    taggedNames <- c()
    for (i in seq(dim(ref)[2])) {
        marker[[i]] <- rownames(ref[ref[,i] > quantile(ref[,i], prob=0.90),])
        taggedNames <- c(taggedNames, paste0(colnames(ref)[i], "%", cellTypeNames[i], toString(i), "%", cellTypeNames[i], toString(i), ".txt"))
    }
    
    names(marker) <- taggedNames#paste0(colnames(ref), "%tag0%tag1")
    
    spill <- list()
    spill[["K"]] <- matrix(1/length(cellTypeNames), nrow = length(cellTypeNames), ncol = length(cellTypeNames), dimnames = list(cellTypeNames, cellTypeNames))
    spill[["fv"]] <- as.data.frame(matrix(1, nrow = length(cellTypeNames), ncol = 3, dimnames = list(cellTypeNames, c("V1", "V2", "V3"))))
    
    xc <- xCellAnalysis(df, file.name = "deconvoluted.tsv", signatures = marker, genes = rownames(df), cell.types.use = cellTypeNames, spill = spill, scale = FALSE)
} else {
    xc <- xCellAnalysis(df, file.name = "deconvoluted.tsv")
}

#write.table(xc, file = "deconvoluted-pvalue.tsv", quote = FALSE, col.names = NA, sep = "\t")
