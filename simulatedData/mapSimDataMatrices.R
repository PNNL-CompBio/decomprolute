library(dplyr)
library(stringr)


main <- function(){

    argv <- commandArgs(trailingOnly = TRUE)
    print(argv)
    deconv.mat <- read.table(argv[1],header=T,row.names=1,sep='\t') #matrix to be fixed
    sig.mat <- argv[2] #signature used to deconvolve matrix
    sim.type <- tolower(argv[3]) #type of simulation performed
    cell.type <-read.table(argv[4],header=T,row.names=1,sep='\t')

    sig.mat<-basename(sig.mat)

    over <- intersect(rownames(deconv.mat),rownames(cell.type))
    print(paste0('Overlapping cell types before mapping (',length(over),'): ',paste(over,collapse=',')))

    ##massive if-else clause to match cell types :-/
    if(sig.mat=='LM9.txt'){
        #can only convert to LM9 or LM7c or PBMC
        if(sim.type=='prot'){
            ##just rename

        }else if(sim.type=='mrna'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('Neutrophil','Neutrophils')%>%
                stringr::str_replace('MO','Monocytes')%>%
                stringr::str_replace('T8 cells','CD8')%>%
                stringr::str_replace('T4 cells','CD4')%>%
                stringr::str_replace('B cells','B-cells')


        }else if(sim.type=='pbmc'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('NK','NK cells')%>%
                stringr::str_replace('MO','Monos')%>%
                stringr::str_replace('T8 cells','CD8 T-cells')

            cell.type['T4 cells',]<-cell.type['CD4 naive T-cells',]+cell.type['CD4 memory T-cells resting',]+cell.type['CD4 memory T-cells activated',]
            cell.type['B cells',]<-cell.type['Naive B cells',]+cell.type['Memory B cells',]
        }
    }else if(sig.mat=='LM22.txt'){
        #can convert to any other
        if(sim.type=='prot'){
            ##fix  t8 cells
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('T cells CD8','T8 cells')%>%
                stringr::str_replace('Neutrophils','Neutrophil')%>%
                stringr::str_replace("Eosinophils","Eosinophil")

            deconv.mat['B cells',]<-deconv.mat['B cells naive',]+deconv.mat['B cells memory',]
            deconv.mat['T4',]<- deconv.mat['T cells CD4 naive',]+deconv.mat['T cells CD4 memory activated',]+deconv.mat['T cells CD4 memory resting',]
            deconv.mat['NK',]<-deconv.mat['NK cells activated',]+deconv.mat['NK cells resting',]
            deconv.mat['DC',]<-deconv.mat['Dendritic cells activated',]+deconv.mat['Dendritic cells resting',]

        }else if(sim.type=='mrna'){
            deconv.mat['B-cells',]<-deconv.mat['B cells naive',]+deconv.mat['B cells memory',]
            deconv.mat['CD4',]<- deconv.mat['T cells CD4 naive',]+deconv.mat['T cells CD4 memory activated',]+deconv.mat['T cells CD4 memory resting',]
            deconv.mat['NK',]<-deconv.mat['NK cells activated',]+deconv.mat['NK cells resting',]
        }else if(sim.type=='pbmc'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('B cells naive','Naive B cells')%>%
                stringr::str_replace('B cells Memory','Memory B cells')%>%
                stringr::str_replace('T cells CD8','CD8 T-cells')%>%
                stringr::str_replace('Monocytes','Monos')%>%
                stringr::str_replace('T cells CD4 naive','CD4 naive T-cells')%>%
                stringr::str_replace('T cells CD4 memory activated','CD4 memory T-cells activated')%>%
                stringr::str_replace('T cells CD4 memory resting','CD4 memory T-cells resting')
            deconv.mat['NK cells',]<-deconv.mat['NK cells resting',]+deconv.mat['NK cells activated',]
        }
    }else if(sig.mat=='LM7c.txt'){
        #can not convert
        if(sim.type=='prot'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('NK cells','NK')

        }else if(sim.type=='mrna'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('MO','Monocytes')%>%
                stringr::str_replace('T8 cells','CD8')%>%
                stringr::str_replace('T4 cells','CD4')%>%
                stringr::str_replace('B cells','B-cells')%>%
                stringr::str_replace('NK cells','NK')

        }else if(sim.type=='pbmc'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace("MO","Monos")%>%
                stringr::str_replace('T8 cells','CD8 T-cells')

            cell.type['T4 cells',]<-cell.type['CD4 naive T-cells',]+cell.type['CD4 memory T-cells resting',]+cell.type['CD4 memory T-cells activated'
                                                                                                                       ,]
            cell.type['B cells',]<-cell.type['Naive B cells',]+cell.type['Memory B cells',]

        }
    }else if(sig.mat=='pbmc.txt'){
        #can only covert to LM7c
        if(sim.type=='prot'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('Monocytes','MO')%>%
                stringr::str_replace('T cells CD8','T8 cells')%>%
                stringr::str_replace('T cells CD4','T4 cells')%>%
                stringr::str_replace('NK cells','NK')%>%
                stringr::str_replace("Dendritic cells","DC")

        }else if(sim.type=='mrna'){
            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace('T cells CD8','CD8')%>%
                stringr::str_replace('T cells CD4','CD4')%>%
                stringr::str_replace('B cells','B-cells')%>%
                stringr::str_replace('NK cells','NK')
        }else if(sim.type=='pbmc'){
            cell.type['T cells CD4',]<-cell.type['CD4 naive T-cells',]+cell.type['CD4 memory T-cells resting',]+cell.type['CD4 memory T-cells activated',]

            cell.type['B cells',]<-cell.type['Naive B cells',]+cell.type['Memory B cells',]

            rownames(deconv.mat)<-rownames(deconv.mat)%>%
                stringr::str_replace("MO","Monos")%>%
                stringr::str_replace('T cells CD8','CD8 T-cells')

        }
    }
    over <- intersect(rownames(deconv.mat),rownames(cell.type))
    print(paste0('Overlapping cell types after mapping',sig.mat,' to ',sim.type,'(',length(over),'): ',paste(over,collapse=',')))

    write.table(deconv.mat,file='fixedDeconv.tsv',sep='\t')
    write.table(cell.type,file='fixedCells.tsv',sep='\t')
}

main()
