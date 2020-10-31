# args <- commandArgs(TRUE)
# file1 <- args[1]
# file2 <- args[2]
# file3 <- args[3]
# fileM <- args[4]

filePro <- "./test/CIBERSORTx_Job76_Adjusted_CCRCC_proteinimputed_LM22.txt"
fileRnaT <- "./test/CIBERSORTx_Job23_Adjusted_CCRCC_T_rna_LM22.txt"
fileRnaN <- "./test/CIBERSORTx_Job1_Adjusted_CCRCC_N_rna_LM22.txt"
fileMap <- "./test/mapping_sampleid.tsv"

dfPro <- read.table(filePro, header = TRUE)
dfRnaT <- read.table(fileRnaT, header = TRUE)
dfRnaN <- read.table(fileRnaN, header = TRUE)
mapping <- read.table(fileMap, header = TRUE)
id1 <- mapping$id1
id2 <- mapping$id2

rnaIDs <- id1[which(dfPro$Mixture == id2)]
rownames(dfPro) <- rnaIDs
rownames(dfRnaT) <- sapply(dfRnaT$Mixture, function(x) paste0(substr(x, 1, 9), ".Tumor"))
rownames(dfRnaN) <- sapply(dfRnaN$Mixture, function(x) paste0(substr(x, 1, 9), ".Normal"))

dfPro <- dfPro[,2:23]
dfRnaT <- dfRnaT[,2:23]
dfRnaN <- dfRnaN[,2:23]

rnaTs <- rnaIDs[which(rnaIDs %in% rownames(dfRnaT))]
rnaNs <- rnaIDs[which(rnaIDs %in% rownames(dfRnaN))] 

dfProT <- dfPro[rnaTs,]
dfProN <- dfPro[rnaNs,]
dfRnaT <- dfRnaT[rnaTs,]
dfRnaN <- dfRnaN[rnaNs,]

cellTypes <- colnames(dfPro)
corT <- sapply(cellTypes, function(x) cor(dfProT[,x], dfRnaT[,x]))
corN <- sapply(cellTypes, function(x) cor(dfProN[,x], dfRnaN[,x]))

library(ggplot2)
corResult <- data.frame(cell.type = cellTypes, tumor = corT, normal = corN)
ggplot(corResult, mapping = aes(x = normal, y = tumor, label = cell.type)) + 
    #geom_label() + 
    xlim(-0.1, 0.75) +
    ylim(-0.1, 0.75) +
    geom_point() + 
    geom_text(size = 2, hjust = 0, nudge_x = 0.015, nudge_y = 0.005)#, angle = 15)


