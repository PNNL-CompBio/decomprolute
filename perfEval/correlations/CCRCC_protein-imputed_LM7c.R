setwd('~/Documents/GitHub/proteomicsTumorDeconv/perfEval/correlations/')
a <- 'CIBERSORTx_Job86_Adjusted_CCRCC_weipingmail_unscaled_LM7c.txt'

tmp <- read.delim(a,check.names = F)
rownames(tmp) <- tmp$Mixture
rownames(tmp) <- gsub('\\.','-',rownames(tmp))
tmp <- tmp[,-1]
aa <- tmp$`Absolute score (sig.score)`
tmp <- tmp[,setdiff(colnames(tmp),c('P-value',"Correlation","RMSE",'Absolute score (sig.score)'))]
for (q in 1: nrow(tmp)) {
  tmp[q,] <- tmp[q,]/aa[q]
}
rel <- tmp

library(readxl)
mmc7 <- read_excel("mmc7.xlsx", sheet = "xCell Signatures", skip = 2)
mmc7 <- mmc7[,-1]
mmc7 <- t(mmc7[1,])
mmc7 <- as.data.frame(mmc7)
colnames(mmc7) <- 'Subtype'
mmc7 <- cbind(mmc7,Tissue=NA)
mmc7$Tissue <- ifelse(mmc7$Subtype %in% c('Pure NAT','Infiltrated NAT'),'Normal','Tumor')
tab <- mmc7
tab$Subtype[tab$Subtype=='CD8- inflamed'] <- "CD8- Inflamed"
tab$Subtype[tab$Subtype=='CD8+ inflamed'] <- "CD8+ Inflamed"
tab$Subtype[tab$Subtype=='VEGF immune-desert'] <- "VEGF Immune-desert"
tab$Subtype[tab$Subtype=='Metabolic immune-desert'] <- "Metabolic Immune-desert"
com <- intersect(rownames(tab),rownames(rel))
tab <- tab[com,]
tab <- cbind(tab,rel[com,])
t <- 'CCRCC'

library(ComplexHeatmap)
immune <- colnames(rel)
mat <- t(tab[,immune])

mat <- t(scale(t(mat)))

which(apply(mat,1,anyNA))
mat[is.na(mat)] <- 0

annot <- rownames(tab[order(tab$Tissue,tab$Subtype),])

tab <- tab[annot,]
mat <- mat[,annot]

set.seed(10)
ha = HeatmapAnnotation(Subtype = tab$Subtype, Tissue = tab$Tissue)

pdf("Heatmap_CCRCC_protein-imputed_LM7c.pdf", width = 20, height = 8)
ht <- Heatmap(mat,name = t,top_annotation = ha,column_names_gp = gpar(fontsize = 4),
        column_names_rot = 45,cluster_rows = F,cluster_columns = F, 
        column_split = factor(tab$Subtype,levels = c("Infiltrated NAT","Pure NAT","CD8- Inflamed","CD8+ Inflamed","Metabolic Immune-desert","VEGF Immune-desert")),
        column_title_gp = gpar(fontsize = 10),column_gap = unit(3, "mm"),border = TRUE)
draw(ht, padding = unit(c(2, 8, 2, 2), "mm")) 
dev.off()

## boxplot ###

library(reshape2)
library(ggpubr)

tmp <- t(mat)
tmp <- cbind(tab[,c(1,2)],tmp)
save(tmp,file = 'CCRCC_weipingmail_unscaled_LM7c.RData')
tabM <- melt(tmp)

tabM$variable <- as.character(tabM$variable)
tabM <- tabM[!tabM$Subtype %in% c('Pure NAT','Infiltrated NAT'),]
col <- ha@anno_list[["Subtype"]]@color_mapping@colors
comp <- list( c("CD8+ Inflamed","CD8- Inflamed"), c("CD8+ Inflamed", "Metabolic Immune-desert"), c("CD8- Inflamed", "Metabolic Immune-desert") )

mult <- list()
for (i in unique(tabM$variable)) {
  print(i)
  tmp <- tabM[tabM$variable==i,]
  p <- ggboxplot(tmp,x='Subtype',y='value',color = 'Subtype',palette = col,add = 'jitter',xlab = F)+
    stat_compare_means(label.x = 2)+stat_compare_means(comparisons = comp,method = 'wilcox.test',step.increase = 0.15) +
    rotate_x_text(angle = 45) 
  p <- ggpar(p,main = i,font.main = 'bold')
  mult[[i]] <- p
}


pmerged <- ggarrange(plotlist = mult,
                     labels = NULL,
                     ncol = 5, nrow = 2,
                     common.legend = TRUE,
                     legend = 'none')

ggsave(pmerged,
       file = 'Boxplot_CCRCC_protein-imputed_LM7c.pdf',
       width = 20,
       height = 15)
