
library(dplyr)
library(argparser)
library(ggplot2)
library(reshape2)

getDfISC <- function(m, iscfile = "/bin/pancan_immune_subtypes.csv") {
    thor <- read.delim(iscfile,sep = ',')
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
    
    m <- t(scale(t(m)))
    m[is.na(m)] <- 0
    
    m2 <- melt(as.matrix(m))
    colnames(m2) <- c("CellTypes", "SampleID", "Values")
    m2$ImmuneSubtype <- thor[m2$SampleID, "Immune.Subtype"]
    
    return(m2)
}

compareImmuneSubtypes<-function(file.list, iscfile = "/bin/pancan_immune_subtypes.csv"){
    message(paste0('Comparing ',length(file.list),' files'))
    sigs <- unique(sapply(strsplit(file.list,'[-\\.]'), function(x) x[6]))
    full.tab<-do.call(rbind,lapply(file.list,function(file){
        vars <- unlist(strsplit(basename(file),split='[-\\.]')) #split into pieces
        cancer=vars[1]
        tissue=vars[2]
        molecule=vars[3]
        imputation=vars[4]
        algorithm=vars[5]
        sigMatrix=vars[6]
        m<-read.table(file,fill=TRUE,check.names=FALSE)
        m2 <- getDfISC(m, iscfile)
        return(data.frame(m2,cancer,tissue,molecule,imputation,algorithm,sigMatrix))
    }))

    for (sig in sigs) {
        full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
        p2<-full.tab.sig%>%
            ggplot(aes(x = molecule, y = Values, fill = algorithm)) +
            geom_bar(position = "dodge", stat = "summary", fun = "median") + 
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
            facet_grid(rows=vars(CellTypes),cols=vars(ImmuneSubtype))
        ggsave(paste0('barplots-immune-subtypes',sig,'.pdf'),p2, width = 10, height = length(unique(full.tab.sig$CellTypes)) * 2)
    }
    
    for (sig in sigs) {
        full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
        p3<-full.tab.sig%>%
            ggplot(aes(x = molecule, y = Values, fill = algorithm)) +
            geom_boxplot(outlier.shape = NA) +
            scale_y_continuous(limits = quantile(full.tab.sig$Values, c(0.01, 0.99))) + 
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
            facet_grid(rows=vars(CellTypes),cols=vars(ImmuneSubtype))
        ggsave(paste0('boxplots-immune-subtypes',sig,'.pdf'),p3, width = 10, height = length(unique(full.tab.sig$CellTypes)) * 2)
    }

    return(full.tab)
}



main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)
    file.list<-argv
    tab<-combineDists(file.list)
    print(dim(tab))
    write.table(tab,paste0('combined-immune-subtypes.tsv'),row.names=F,col.names=T)
}

main()
