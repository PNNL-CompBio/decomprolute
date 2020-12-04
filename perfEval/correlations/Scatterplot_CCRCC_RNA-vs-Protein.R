library(ggpubr)
load("~/Documents/GitHub/proteomicsTumorDeconv/perfEval/correlations/CCRCC_RNA_paper_sc3PBMC.RData")
rna <- tmp
load("~/Documents/GitHub/proteomicsTumorDeconv/perfEval/correlations/CCRCC_weipingmail_unscaled_LM7c.RData")
prot <- tmp
col <- ha@anno_list[["Subtype"]]@color_mapping@colors
identical(prot[,1:2],rna[,1:2]) #true
mult <- list()
for (i in c(3,4,5,6,8,9)) {
  tmp <- cbind(rna[,c(1,2,i)],prot[,i])
  colnames(tmp)[4] <- colnames(prot)[i]
  p <- ggscatter(tmp, x = colnames(tmp)[3], y = colnames(tmp)[4],
                 add = "reg.line",                                 
                 conf.int = TRUE,xlab = paste0('RNA-',colnames(tmp)[3]),
                 ylab = paste0('Protein-',colnames(tmp)[4]),title = colnames(tmp)[3],                            
                 add.params = list(color = "blue",
                                   fill = "lightgray"),
                 color = 'Subtype',palette = col,size = 2)+
    stat_cor(method = "spearman",cor.coef.name = "rho")
  p <- ggpar(p,font.main='bold')
  mult[[colnames(tmp)[3]]] <- p
}

pmerged <- ggarrange(plotlist = mult,
                     labels = NULL,
                     ncol = 3, nrow = 2, 
                     common.legend = TRUE,
                     legend = 'right')

ggsave(pmerged,
       file = 'Scatterplot_CCRCC_RNA-vs-Protein.pdf',
       width = 20,
       height = 15)
