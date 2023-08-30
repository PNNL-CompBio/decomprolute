library(dplyr)
library(argparser)
library(ggplot2)
library(reshape2)
library(nationalparkcolors)
#general colors used
pal <- c(park_palette('GeneralGrant'),
         park_palette('Redwoods'),
         park_palette('DeathValley'),
         park_palette('Acadia'))

getDfISC <- function(m, thor) {

  ##first we get common patients
    com <- intersect(colnames(m),rownames(thor))
    m <- m[,com]
   # print(m)
    
    ##then we get cell types
    CellTypes=rownames(m)
    thor <- thor[com,]
    m <- t(scale(t(m)))
    m[is.na(m)] <- 0
#    print(m)
    m2 <- melt(as.matrix(m))
  #  print(m)
    colnames(m2) <- c("CellTypes", "SampleID", "Values")
    m2$CellTypes=CellTypes
    m2$ImmuneSubtype <- thor[m2$SampleID, "Immune.Subtype"]
    return(m2)
}


compareImmuneSubtypes<-function(file.list, iscfile = "/bin/pancan_immune_subtypes.csv"){
    message(paste0('Comparing ',length(file.list),' files'))

    thor <- read.delim(iscfile,sep = ',')#,check.names==F)
    thor$Sample.ID <- gsub('.A','.N',thor$Sample.ID)
    thor$Sample.ID <- gsub('.T','',thor$Sample.ID)
    rownames(thor) <- thor$Sample.ID
    thor$Immune.Subtype[thor$Immune.Subtype==1] <- "C1-WoundHealing"
    thor$Immune.Subtype[thor$Immune.Subtype==2] <- "C2-IFNGammaDominant"
    thor$Immune.Subtype[thor$Immune.Subtype==3] <- "C3-Inflammatory"
    thor$Immune.Subtype[thor$Immune.Subtype==4] <- "C4-LymphocyteDepleted"
    thor$Immune.Subtype[thor$Immune.Subtype==5] <- "C5-ImmunologicallyQuiet"
    thor$Immune.Subtype[thor$Immune.Subtype==6] <- "C6-TGFBetaDominant"
    thor <- thor[,-1]

    sigs <- unique(sapply(file.list,function(x) unlist(strsplit(gsub('.tsv','',basename(x)),'-',fixed=T))[6]))
    full.tab<-do.call(rbind,lapply(file.list,function(file){
        vars <- unlist(strsplit(basename(file),split='[-\\.]')) #split into pieces
        cancer=vars[1]
        tissue=vars[2]
        molecule=vars[3]
        imputation=vars[4]
        algorithm=vars[5]
        sigMatrix=vars[6]
        m<-read.table(file,sep='\t',header=T,check.names=T)%>%
            tibble::column_to_rownames('X')
        colnames(m)<-gsub(".T",'',colnames(m))
        m2 <- getDfISC(m, thor)
        return(data.frame(m2,cancer,tissue,molecule,imputation,algorithm,sigMatrix))
    }))

     write.table(full.tab,file='combined-deconv-preds.tsv',sep='\t')
     
     return(full.tab)
}
     
doPlots<-function(full.tab){
  ##this function does three plots
     molecules <- unique(full.tab$molecule)
     sigs <- unique(full.tab$sigMatrix)
     
     ##first we do histogram plot
    for (sig in sigs) {
        for (mol in molecules) {
            print(sig)
            full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
            mu <- full.tab.sig%>%
                group_by(CellTypes,algorithm,ImmuneSubtype)%>%
                summarise(median=median(Values))
            p1<-full.tab.sig%>%
                ggplot(aes(x = Values, fill = algorithm)) +
                geom_histogram(alpha=0.6,position = 'identity',bins = 50)+ #choose a useful number of bins
                #geom_bar(position = "dodge", stat = "summary", fun = "median") +
                theme_classic()+geom_vline(data=mu, aes(xintercept=median, color=algorithm),size=.8)+
                #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
                geom_vline(xintercept = 0,size=.8,linetype="dashed")+
                facet_grid(rows=vars(CellTypes),cols=vars(ImmuneSubtype), scales = 'free') +
                theme(strip.text.y = element_text(angle = 0),panel.background = element_rect(fill = "grey92"))+
                coord_cartesian(xlim =c(-1.5, 1.5))+scale_fill_manual(values=pal)+
                                        scale_color_manual(values=pal)#, ylim = c(10, 20)
            color = c('C1-WoundHealing'='red','C2-IFNGammaDominant'='yellow','C3-Inflammatory'='green3','C4-LymphocyteDepleted'='cyan','C5-ImmunologicallyQuiet'='blue','C6-TGFBetaDominant'='magenta')

            tmp3 <- sort(unique(full.tab.sig$algorithm))#sapply(strsplit(full.tab.sig$algorithm,' '), function(x) x[1])))
            color <- color[tmp3]

            g <- ggplot_gtable(ggplot_build(p1))
            strip_both <- which(grepl('strip-', g$layout$name))
            fills <- color
            k <- 1
            for (i in strip_both) {
                j <- which(grepl('rect', g$grobs[[i]]$grobs[[1]]$childrenOrder))
                g$grobs[[i]]$grobs[[1]]$children[[j]]$gp$fill <- fills[k]
                k <- k+1
            }
            ggsave(paste0('histplots-immune-subtypes-',sig, '-', mol, '.pdf'),p1, width = 10, height = length(unique(full.tab.sig$CellTypes)) * 2)
        }
    }
     
    ##then we do barplots
    for (sig in sigs) {
        full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
        p2<-full.tab.sig%>%
            ggplot(aes(x = molecule, y = Values, fill = algorithm)) +
            geom_bar(position = "dodge", stat = "summary", fun = "median") +
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
            facet_grid(rows=vars(CellTypes),cols=vars(ImmuneSubtype))+scale_fill_manual(values=pal)
        ggsave(paste0('barplots-immune-subtypes-',sig,'.pdf'),p2, width = 10, height = length(unique(full.tab.sig$CellTypes)) * 2)
    }

     ##boxplots show a distinct different profile
    for (sig in sigs) {
        full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
        p3<-ggplot(full.tab.sig,aes(x=ImmuneSubtype,y=Values,col=CellTypes,fill=CellTypes))+
          geom_boxplot()+
          facet_grid(algorithm~cancer)+
        #p3<-full.tab.sig%>%
        #    ggplot(aes(x = molecule, y = Values, fill = algorithm)) +
        #    geom_boxplot(outlier.shape = NA) +
            scale_y_continuous(limits = quantile(full.tab.sig$Values, c(0.01, 0.99))) +
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
          #  facet_grid(rows=vars(CellTypes),cols=vars(ImmuneSubtype))+
          scale_fill_manual(values=pal)+
          scale_color_manual(values=pal)
        ggsave(paste0('boxplots-immune-subtypes-',sig,'.pdf'),p3, width = 10, height = length(unique(full.tab.sig$algorithm)) * 2.5)
    }
     
     ##now do the ridgelines
     library(ggridges)
     for(sig in sigs){
       
       full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
       
       color = c('C1-WoundHealing'='red','C2-IFNGammaDominant'='yellow','C3-Inflammatory'='green3','C4-LymphocyteDepleted'='cyan','C5-ImmunologicallyQuiet'='blue','C6-TGFBetaDominant'='magenta')
 
       tmp3 <- sort(unique(full.tab.sig$ImmuneSubtype))#sapply(strsplit(full.tab.sig$algorithm,' '), function(x) x[1])))
       color <- color[tmp3]
       
       p4<-ggplot(full.tab.sig,aes(x=Values,y=CellTypes,fill=ImmuneSubtype,alpha=0.3))+
         geom_density_ridges()+xlim(-3,3)+
         facet_grid(cancer~algorithm)+
         scale_fill_manual(values=color)+
         scale_color_manual(values=color)
       ggsave(paste0('ridgelines-immune-alg-cancer-',sig,'.pdf'),p4, width = 12, 
              height = length(unique(full.tab.sig$CellTypes)) * 1.5)
  
       
       p4<-ggplot(full.tab.sig,aes(x=Values,y=CellTypes,fill=ImmuneSubtype,alpha=0.3))+
         geom_density_ridges()+xlim(-3,3)+
         facet_grid(.~algorithm)+
         scale_fill_manual(values=color)+
         scale_color_manual(values=color)
       ggsave(paste0('ridgelines-immune-alg-all',sig,'.pdf'),p4, width = 12, 
              height = length(unique(full.tab.sig$CellTypes))*.5)
    
           
       full.tab.sig2 <- full.tab[full.tab$sigMatrix == sig, ]
       color = pal
       
       p5<-ggplot(full.tab.sig2,aes(x=Values,y=CellTypes,fill=algorithm,alpha=0.8))+
         geom_density_ridges()+xlim(-3,3)+
         facet_grid(cancer~ImmuneSubtype)+
         scale_fill_manual(values=color)+
         scale_color_manual(values=color)
       ggsave(paste0('ridgelines-immune-subtypes-cancer-',sig,'.pdf'),p5, width = 12, 
              height = length(unique(full.tab.sig2$CellTypes))*1.5)
       
       ##now do one with the entire data summarized!!
       p6<-ggplot(full.tab.sig2,aes(x=Values,y=CellTypes,fill=algorithm,alpha=0.8))+
         geom_density_ridges()+xlim(-3,3)+
         facet_grid(.~ImmuneSubtype)+
         scale_fill_manual(values=color)+
         scale_color_manual(values=color)
       ggsave(paste0('ridgelines-immune-subtypes-all-',sig,'.pdf'),p6, width = 12, 
              height = length(unique(full.tab.sig2$CellTypes))*0.5)
       
       
     }
     
    return(full.tab)

}



main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)
    file.list<-argv
    tab<-compareImmuneSubtypes(file.list)
    plots<-doPlots(tab)
#    print(dim(tab))
    write.table(tab,paste0('combined-immune-subtypes.tsv'),row.names=F,col.names=T)
}

main()
