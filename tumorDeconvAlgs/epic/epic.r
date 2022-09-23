#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
if (!is.null(args[1])) {
    df <- read.csv(args[1], sep = "\t", row.names = 1, check.names=F)
    if (max(df, na.rm = TRUE) < 50) {
        df <- 2^df
    }
    # df <- df[rowSums(is.na(df)) != ncol(df), ]
    df[is.na(df)] <- 0.0
} else {
    stop("No expression matrix provided!")
}

library(matrixStats)
library(EPIC)

if (length(args) > 1) {
    ref <- read.csv(args[2], sep = "\t", row.names = 1, check.names=F) ### Need to change later
    cellTypeNames <- colnames(ref)
    markerGenes <- c()
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
            # tempMarkers <- rownames(ref[ref[,s] > quantile(ref[,s], prob=0.5),])
            deOverMedians <- (ref[tempMarkers,s] - rowMedians(as.matrix(ref[tempMarkers,])))/rowMedians(as.matrix(ref[tempMarkers,]))
            markers <- tempMarkers[deOverMedians > quantile(deOverMedians, prob=0.9)]
        }
        genesTemp <- markers
        markerGenes <- c(markerGenes, genesTemp)
        # genesNull <- rownames(ref)[!(rownames(ref) %in% genesTemp)]
        # ref[genesNull, s] <- 0.0
    }
    markerGenes <- unique(markerGenes)

    epicRef <- list()
    epicRef$sigGenes <- markerGenes

    sigMatName <- tools::file_path_sans_ext(basename(args[2]))
    meanFile <- paste0("/data/", sigMatName, "_refMean.txt")
    stdFile <- paste0("/data/", sigMatName, "_refStd.txt")
    if (file.exists(meanFile)) {
        epicRef$refProfiles <- read.csv(meanFile, sep = "\t", row.names = 1, check.names=F)
    } else {
        epicRef$refProfiles <- ref
        warning("Reference profile was not provided or can not be found, using the signature matrix instead\n")
    }
    if (file.exists(stdFile)) {
        epicRef$refProfiles.var <- read.csv(stdFile, sep = "\t", row.names = 1, check.names=F)
    }
    tryCatch(
        expr = {
            xc <- EPIC(bulk = df, reference = epicRef)

            results <- xc$cellFractions
            results <- results[,colnames(results) != "otherCells"]
            write.table(t(results), file = "deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
        },
        error = function(e){
            # (Optional)
            # Do this if an error is caught...
            print(e)
            Y <- read.csv(args[1], sep = "\t", check.names=F)
            X <- read.csv(args[2], sep = "\t", row.names = 1, check.names=F)
            results <- matrix(0, nrow = length(colnames(Y)) - 1, ncol = length(colnames(X)), dimnames = list(colnames(Y)[2:length(colnames(Y))], colnames(X)))
            write.table(t(results), file="deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
        }
    )
} else {
    xc <- EPIC(bulk = df)

    results <- xc$cellFractions
    write.table(t(results), file = "deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
}
