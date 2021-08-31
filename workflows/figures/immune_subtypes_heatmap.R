
library(dplyr)
library(argparser)
library(ggplot2)

#rna
tmp <- list.files()[grep('tumor-mrna',list.files())]
tmp <- tmp[grep('xcell',tmp)]
tmp2 <- strsplit(tmp,'\\.')[[1]][1]
tmp <- read.delim(tmp[1],row.names = 1)

thor <- read.delim('pancan_immune_subtypes.csv',sep = ',')
thor$Sample.ID <- gsub('.A','.N',thor$Sample.ID)
thor$Sample.ID <- gsub('.T','',thor$Sample.ID)
rownames(thor) <- thor$Sample.ID
thor <- thor[,-1]

noisc <- setdiff(colnames(tmp),rownames(thor))
message(paste0('Number of samples without ISC: ',length(noisc)))

com <- intersect(colnames(tmp),rownames(thor))

tmp <- tmp[,com]
thor <- thor[com,]

thor$Immune.Subtype[thor$Immune.Subtype==1] <- "C1-WoundHealing"
thor$Immune.Subtype[thor$Immune.Subtype==2] <- "C2-IFNGammaDominant"
thor$Immune.Subtype[thor$Immune.Subtype==3] <- "C3-Inflammatory"
thor$Immune.Subtype[thor$Immune.Subtype==4] <- "C4-LymphocyteDepleted"
thor$Immune.Subtype[thor$Immune.Subtype==5] <- "C5-ImmunologicallyQuiet"
thor$Immune.Subtype[thor$Immune.Subtype==6] <- "C6-TGFBetaDominant"

mat_rna <- t(scale(t(tmp)))

which(apply(mat_rna,1,anyNA))
mat_rna[is.na(mat_rna)] <- 0

library(ComplexHeatmap)
ha = HeatmapAnnotation(ISC=thor$Immune.Subtype,
                       col = list(Subtype = c('NAT enriched' = "antiquewhite4", 'Cold-tumor enriched' = "darkorchid", 'Hot-tumor enriched' = "coral"),
                                  Tissue = c("NAT" = "darkgrey", "Tumor" = "darkred"),ISC=c('C1-WoundHealing'='red','C2-IFNGammaDominant'='yellow','C3-Inflammatory'='green3','C4-LymphocyteDepleted'='cyan','C5-ImmunologicallyQuiet'='blue','C6-TGFBetaDominant'='magenta')))

pdf(paste0(tmp2,".pdf"), width = 20, height = 8)
ht <- Heatmap(mat_rna,name = 'Z-score',top_annotation = ha,column_names_gp = gpar(fontsize = 4),
              column_names_rot = 45,cluster_rows = F,cluster_columns = F,
              column_title_gp = gpar(fontsize = 10))
draw(ht, padding = unit(c(2, 8, 2, 2), "mm")) 
dev.off()

#prot
tmp <- list.files()[grep('prot-deconv.tsv',list.files())]
tmp <- tmp[grep('xcell',tmp)]
tmp2 <- strsplit(tmp,'\\.')[[1]][1]
tmp <- read.delim(tmp,row.names = 1)

thor <- read.delim('pancan_immune_subtypes.csv',sep = ',')
thor$Sample.ID <- gsub('.A','.N',thor$Sample.ID)
thor$Sample.ID <- gsub('.T','',thor$Sample.ID)
rownames(thor) <- thor$Sample.ID
thor <- thor[,-1]

noisc <- setdiff(colnames(tmp),rownames(thor))
message(paste0('Number of samples without ISC: ',length(noisc)))

com <- intersect(colnames(tmp),rownames(thor))

tmp <- tmp[,com]
thor <- thor[com,]

thor$Immune.Subtype[thor$Immune.Subtype==1] <- "C1-WoundHealing"
thor$Immune.Subtype[thor$Immune.Subtype==2] <- "C2-IFNGammaDominant"
thor$Immune.Subtype[thor$Immune.Subtype==3] <- "C3-Inflammatory"
thor$Immune.Subtype[thor$Immune.Subtype==4] <- "C4-LymphocyteDepleted"
thor$Immune.Subtype[thor$Immune.Subtype==5] <- "C5-ImmunologicallyQuiet"
thor$Immune.Subtype[thor$Immune.Subtype==6] <- "C6-TGFBetaDominant"

mat_prot <- t(scale(t(tmp)))

which(apply(mat_prot,1,anyNA))
mat_prot[is.na(mat_prot)] <- 0

library(ComplexHeatmap)
ha = HeatmapAnnotation(ISC=thor$Immune.Subtype,
                       col = list(Subtype = c('NAT enriched' = "antiquewhite4", 'Cold-tumor enriched' = "darkorchid", 'Hot-tumor enriched' = "coral"),
                                  Tissue = c("NAT" = "darkgrey", "Tumor" = "darkred"),ISC=c('C1-WoundHealing'='red','C2-IFNGammaDominant'='yellow','C3-Inflammatory'='green3','C4-LymphocyteDepleted'='cyan','C5-ImmunologicallyQuiet'='blue','C6-TGFBetaDominant'='magenta')))

pdf(paste0(tmp2,".pdf"), width = 20, height = 8)
ht <- Heatmap(mat_prot,name = 'Z-score',top_annotation = ha,column_names_gp = gpar(fontsize = 4),
              column_names_rot = 45,cluster_rows = F,cluster_columns = F,
              column_title_gp = gpar(fontsize = 10))
draw(ht, padding = unit(c(2, 8, 2, 2), "mm")) 
dev.off()