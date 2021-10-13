library(dplyr)
library(argparser)
library(ggplot2)
library(reshape2)
library(nationalparkcolors)

pal <- c(park_palette('GeneralGrant'),park_palette('Redwoods'))

getDfISC <- function(m, thor) {

    com <- intersect(colnames(m),rownames(thor))
    m <- m[,com]
   # print(m)
    CellTypes=rownames(m)
    thor <- thor[com,]
    m <- t(scale(t(m)))
    m[is.na(m)] <- 0
#    print(m)
    m2 <- melt(as.matrix(m))
    colnames(m2) <- c("CellTypes", "SampleID", "Values")
    m2$CellTypes=CellTypes
    m2$ImmuneSubtype <- thor[m2$SampleID, "Immune.Subtype"]
  #  print(m2)
    return(m2)
}


compareImmuneSubtypes<-function(file.list, iscfile = "/bin/pancan_immune_subtypes.csv"){
    message(paste0('Comparing ',length(file.list),' files'))

    thor <- read.delim(iscfile,sep = ',')
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
#    print(sigs)
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
        m2 <- getDfISC(m, thor)
        return(data.frame(m2,cancer,tissue,molecule,imputation,algorithm,sigMatrix))
    }))

     molecules <- unique(full.tab$molecule)
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
    for (sig in sigs) {
        full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
        p2<-full.tab.sig%>%
            ggplot(aes(x = molecule, y = Values, fill = algorithm)) +
            geom_bar(position = "dodge", stat = "summary", fun = "median") +
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
            facet_grid(rows=vars(CellTypes),cols=vars(ImmuneSubtype))+scale_fill_manual(values=pal)
        ggsave(paste0('barplots-immune-subtypes-',sig,'.pdf'),p2, width = 10, height = length(unique(full.tab.sig$CellTypes)) * 2)
    }

    for (sig in sigs) {
        full.tab.sig <- full.tab[full.tab$sigMatrix == sig, ]
        p3<-full.tab.sig%>%
            ggplot(aes(x = molecule, y = Values, fill = algorithm)) +
            geom_boxplot(outlier.shape = NA) +
            scale_y_continuous(limits = quantile(full.tab.sig$Values, c(0.01, 0.99))) +
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
            facet_grid(rows=vars(CellTypes),cols=vars(ImmuneSubtype))+scale_fill_manual(values=pal)
        ggsave(paste0('boxplots-immune-subtypes-',sig,'.pdf'),p3, width = 10, height = length(unique(full.tab.sig$CellTypes)) * 2)
    }

    return(full.tab)

}



main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)
    file.list<-argv
    tab<-compareImmuneSubtypes(file.list)
#    tab<-combineDists(file.list)
    print(dim(tab))
    write.table(tab,paste0('combined-immune-subtypes.tsv'),row.names=F,col.names=T)
}

main()
