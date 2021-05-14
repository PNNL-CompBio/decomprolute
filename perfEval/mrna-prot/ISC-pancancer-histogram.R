setwd('perfEval/mrna-prot/')
library(plyr)
library(ggplot2)
library(grid)

#rna
tmp <- list.files()[grep('tumor-mrna',list.files())]
tmp <- tmp[grep('tsv$',tmp)]
sig <- unique(sapply(strsplit(tmp,'-'), function(x) x[6]))
sig <- sapply(strsplit(sig,'\\.'), function(x) x[1])


for (s in sig) {
  total <- NULL
  sel_sig <- tmp[grep(s,tmp)]
  tum <- unique(sapply(strsplit(sel_sig,'-'), function(x) x[1]))
  for (t in tum) {
    select <- sel_sig[grep(t,sel_sig)]
    m <- read.delim(select[1],row.names = 1)
    met <- sapply(strsplit(select[1],'-'), function(x) x[5])
    rownames(m) <- paste0(rownames(m),'_',met)
    m <- t(scale(t(m)))
    m[is.na(m)] <- 0
    
    if (length(select)>1) {
      for (tsv in select[2:length(select)]) {
        m2 <- read.delim(tsv,row.names = 1)
        met <- sapply(strsplit(tsv,'-'), function(x) x[5])
        rownames(m2) <- paste0(rownames(m2),'_',met)
        m2 <- as.matrix(m2)
        m2 <- t(scale(t(m2)))
        m2[is.na(m2)] <- 0
        
        com <- intersect(colnames(m),colnames(m2))
        m <- rbind(m[,com],m2[,com])
        # if (identical(colnames(m),colnames(m2))) {
        #   m <- rbind(m,m2)
        # } else {
        #   stop()
        # }
      }
    }
    total <- cbind(total,m)
  }
  assign(paste0('Pan_cancer-',s),total)
}

ob <- ls()
ob <- ob[grep('^Pan_',ob)]

for (o in ob) {
  
  m <- get(o)
  thor <- read.delim('../figures/pancan_immune_subtypes.csv',sep = ',')
  thor$Sample.ID <- gsub('.A','.N',thor$Sample.ID)
  thor$Sample.ID <- gsub('.T','',thor$Sample.ID)
  rownames(thor) <- thor$Sample.ID
  thor <- thor[,-1]
  
  com <- intersect(colnames(m),rownames(thor))
  m <- m[,com]
  thor <- thor[com,]
  
  thor$Immune.Subtype[thor$Immune.Subtype==1] <- "C1-WoundHealing"
  thor$Immune.Subtype[thor$Immune.Subtype==2] <- "C2-IFNGammaDominant"
  thor$Immune.Subtype[thor$Immune.Subtype==3] <- "C3-Inflammatory"
  thor$Immune.Subtype[thor$Immune.Subtype==4] <- "C4-LymphocyteDepleted"
  thor$Immune.Subtype[thor$Immune.Subtype==5] <- "C5-ImmunologicallyQuiet"
  thor$Immune.Subtype[thor$Immune.Subtype==6] <- "C6-TGFBetaDominant"
  
  sam_cl <- list()
  for (tt in sort(unique(thor$Immune.Subtype))) {
    tmp3 <- na.exclude(rownames(thor)[thor$Immune.Subtype==tt])
    sam_cl[[tt]] <- tmp3
  }
  
  tmp2 <- as.data.frame(m)
  tmp2 <- cbind(Method=sapply(strsplit(rownames(tmp2),'_'), function(x) x[2]),tmp2)
  tmp2 <- cbind(type=sapply(strsplit(rownames(tmp2),'_'), function(x) x[1]),tmp2)
  tmp2 <- reshape2::melt(tmp2)
  tmp2$variable <- as.character(tmp2$variable)
  tmp2 <- cbind(cluster=NA,tmp2)
  
  for (k in names(sam_cl)) {
    tmp2$cluster[tmp2$variable %in% sam_cl[[k]]] <- paste0(k,' (',length(sam_cl[[k]]),')')
  }

  mu <- ddply(tmp2, c("type","Method",'cluster'), summarise, median=median(value))
  
  p <- ggplot(tmp2,aes(x=value,fill=Method,color=Method))+geom_histogram(alpha=0.2,position = 'identity')+facet_grid(type~ cluster,scales = 'free')+
    theme_classic()+geom_vline(data=mu, aes(xintercept=median, color=Method),size=.8)+geom_vline(xintercept = 0,size=.8)+
    theme(strip.text.y = element_text(angle = 0))
  
  color = c('C1-WoundHealing'='red','C2-IFNGammaDominant'='yellow','C3-Inflammatory'='green3','C4-LymphocyteDepleted'='cyan','C5-ImmunologicallyQuiet'='blue','C6-TGFBetaDominant'='magenta')
  tmp3 <- sort(unique(sapply(strsplit(tmp2$cluster,' '), function(x) x[1])))
  color <- color[tmp3]
  
  g <- ggplot_gtable(ggplot_build(p))
  strip_both <- which(grepl('strip-', g$layout$name))
  fills <- color
  k <- 1
  for (i in strip_both) {
    j <- which(grepl('rect', g$grobs[[i]]$grobs[[1]]$childrenOrder))
    g$grobs[[i]]$grobs[[1]]$children[[j]]$gp$fill <- fills[k]
    k <- k+1
  }
  pdf(paste0(o,'-mrnaHist',".pdf"), width = ifelse(grepl('LM22',o),15,10), height = ifelse(grepl('LM22',o),20,15))
  grid.draw(g)
  dev.off()
  
}

#prot
tmp <- list.files()[grep('tumor-prot',list.files())]
tmp <- tmp[grep('tsv$',tmp)]
sig <- unique(sapply(strsplit(tmp,'-'), function(x) x[6]))
sig <- sapply(strsplit(sig,'\\.'), function(x) x[1])


for (s in sig) {
  total <- NULL
  sel_sig <- tmp[grep(s,tmp)]
  tum <- unique(sapply(strsplit(sel_sig,'-'), function(x) x[1]))
  for (t in tum) {
    select <- sel_sig[grep(t,sel_sig)]
    m <- read.delim(select[1],row.names = 1)
    met <- sapply(strsplit(select[1],'-'), function(x) x[5])
    rownames(m) <- paste0(rownames(m),'_',met)
    m <- t(scale(t(m)))
    m[is.na(m)] <- 0
    
    if (length(select)>1) {
      for (tsv in select[2:length(select)]) {
        m2 <- read.delim(tsv,row.names = 1)
        met <- sapply(strsplit(tsv,'-'), function(x) x[5])
        rownames(m2) <- paste0(rownames(m2),'_',met)
        m2 <- as.matrix(m2)
        m2 <- t(scale(t(m2)))
        m2[is.na(m2)] <- 0
        
        com <- intersect(colnames(m),colnames(m2))
        m <- rbind(m[,com],m2[,com])
        # if (identical(colnames(m),colnames(m2))) {
        #   m <- rbind(m,m2)
        # } else {
        #   stop()
        # }
      }
    }
    total <- cbind(total,m)
  }
  assign(paste0('Pan_cancer-',s),total)
}

ob <- ls()
ob <- ob[grep('^Pan_',ob)]

for (o in ob) {
  
  m <- get(o)
  thor <- read.delim('../figures/pancan_immune_subtypes.csv',sep = ',')
  thor$Sample.ID <- gsub('.A','.N',thor$Sample.ID)
  thor$Sample.ID <- gsub('.T','',thor$Sample.ID)
  rownames(thor) <- thor$Sample.ID
  thor <- thor[,-1]
  
  com <- intersect(colnames(m),rownames(thor))
  m <- m[,com]
  thor <- thor[com,]
  
  thor$Immune.Subtype[thor$Immune.Subtype==1] <- "C1-WoundHealing"
  thor$Immune.Subtype[thor$Immune.Subtype==2] <- "C2-IFNGammaDominant"
  thor$Immune.Subtype[thor$Immune.Subtype==3] <- "C3-Inflammatory"
  thor$Immune.Subtype[thor$Immune.Subtype==4] <- "C4-LymphocyteDepleted"
  thor$Immune.Subtype[thor$Immune.Subtype==5] <- "C5-ImmunologicallyQuiet"
  thor$Immune.Subtype[thor$Immune.Subtype==6] <- "C6-TGFBetaDominant"
  
  sam_cl <- list()
  for (tt in sort(unique(thor$Immune.Subtype))) {
    tmp3 <- na.exclude(rownames(thor)[thor$Immune.Subtype==tt])
    sam_cl[[tt]] <- tmp3
  }
  
  tmp2 <- as.data.frame(m)
  tmp2 <- cbind(Method=sapply(strsplit(rownames(tmp2),'_'), function(x) x[2]),tmp2)
  tmp2 <- cbind(type=sapply(strsplit(rownames(tmp2),'_'), function(x) x[1]),tmp2)
  tmp2 <- reshape2::melt(tmp2)
  tmp2$variable <- as.character(tmp2$variable)
  tmp2 <- cbind(cluster=NA,tmp2)
  
  for (k in names(sam_cl)) {
    tmp2$cluster[tmp2$variable %in% sam_cl[[k]]] <- paste0(k,' (',length(sam_cl[[k]]),')')
  }
  
  library(plyr)
  mu <- ddply(tmp2, c("type","Method",'cluster'), summarise, median=median(value))
  
  p <- ggplot(tmp2,aes(x=value,fill=Method,color=Method))+geom_histogram(alpha=0.2,position = 'identity')+facet_grid(type~ cluster,scales = 'free')+
    theme_classic()+geom_vline(data=mu, aes(xintercept=median, color=Method),size=.8)+geom_vline(xintercept = 0,size=.8)+
    theme(strip.text.y = element_text(angle = 0))
  
  color = c('C1-WoundHealing'='red','C2-IFNGammaDominant'='yellow','C3-Inflammatory'='green3','C4-LymphocyteDepleted'='cyan','C5-ImmunologicallyQuiet'='blue','C6-TGFBetaDominant'='magenta')
  tmp3 <- sort(unique(sapply(strsplit(tmp2$cluster,' '), function(x) x[1])))
  color <- color[tmp3]
  
  g <- ggplot_gtable(ggplot_build(p))
  strip_both <- which(grepl('strip-', g$layout$name))
  fills <- color
  k <- 1
  for (i in strip_both) {
    j <- which(grepl('rect', g$grobs[[i]]$grobs[[1]]$childrenOrder))
    g$grobs[[i]]$grobs[[1]]$children[[j]]$gp$fill <- fills[k]
    k <- k+1
  }
  pdf(paste0(o,'-protHist',".pdf"), width = ifelse(grepl('LM22',o),15,10), height = ifelse(grepl('LM22',o),20,15))
  grid.draw(g)
  dev.off()
  
}
