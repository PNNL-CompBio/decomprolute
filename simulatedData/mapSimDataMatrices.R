library(dplyr)
library(stringr)


main <- function(){

    argv <- commandArgs(trailingOnly = TRUE)
    print(argv)
    deconv.mat <- read.table(argv[1],header=T,row.names=1,sep='\t', check.names = F) #matrix to be fixed
    sig.mat <- argv[2] #signature used to deconvolve matrix
    sig.mat<-basename(sig.mat)
    sig.mat <-stringr::str_replace(sig.mat,'_[0-9]*','') ##added this due to sampling changes!!!
    sim.type <- tolower(argv[3]) #type of simulation performed
    cell.type <-read.table(argv[4],header=T,row.names=1,sep='\t', check.names = F)


    print(paste("mapping",sig.mat,"predictions to",sim.type,'simulations'))
    over <- intersect(rownames(deconv.mat),rownames(cell.type))
    print(paste0('Sig cell types: ',paste(rownames(deconv.mat),collapse=',')))
    print(paste0('Simulated cell types: ',paste(rownames(cell.type),collapse=',')))
    print(paste0('Overlapping cell types before mapping (',length(over),'): ',paste(over,collapse=',')))


    ##let's standardize the way we rename deconvoluted matrices to
    ##maximize overlap
    rownames(deconv.mat)<-rownames(deconv.mat)%>%
        stringr::str_replace('Neutrophil$','Neutrophils')%>%
        stringr::str_replace(stringr::fixed('MO'),'Monocytes')%>%
        stringr::str_replace('^T8 cells$','CD8 T cells')%>%
        stringr::str_replace('^T4 cells$','CD4 T cells')%>%
        stringr::str_replace(fixed('B-cells'),'B cells')%>%
        stringr::str_replace(fixed('B cells naive'),'Naive B cells')%>%
        stringr::str_replace(fixed('B cells memory'),'Memory B cells')%>%
        stringr::str_replace(fixed('T cells CD8'),'CD8 T cells')%>%
        stringr::str_replace('^NK$','NK cells')%>%
        stringr::str_replace('DC$','Dendritic cells')%>%
        stringr::str_replace(fixed('T cells CD4'),'CD4 T cells')%>%
        stringr::str_replace('Eosinophil$','Eosinophils')%>%
        stringr::str_replace(fixed('T cells CD4 naive'),'CD4 naive T cells')%>%
        stringr::str_replace(fixed('T cells CD4 memory activated'),'CD4 memory T cells activated')%>%
        stringr::str_replace(fixed('T cells CD4 memory resting'),'CD4 memory T cells resting')|>
      stringr::str_replace(fixed('CD4 T cells naive'),'CD4 naive T cells')%>%
      stringr::str_replace(fixed('CD4 T cells memory activated'),'CD4 memory T cells activated')%>%
      stringr::str_replace(fixed('CD4 T cells memory resting'),'CD4 memory T cells resting')

    ##now let's get the cell types to use the same nomenclature
    rownames(cell.type)<-rownames(cell.type)%>%
        stringr::str_replace(fixed('B-cells'),'B cells')%>%
        stringr::str_replace('^CD8$','CD8 T cells')%>%
        stringr::str_replace('^CD4$','CD4 T cells')%>%
        stringr::str_replace('^T8 cells$','CD8 T cells')%>%
        stringr::str_replace('^T4 cells$','CD4 T cells')%>%
    stringr::str_replace(fixed('CD8 T-cells'),'CD8 T cells')%>%
        stringr::str_replace(fixed('Monos'),'Monocytes')%>%
        stringr::str_replace(fixed('MO'),'Monocytes')%>%
    stringr::str_replace('Neutrophil$','Neutrophils')%>%
        stringr::str_replace('Eosinophil$','Eosinophils')%>%
        stringr::str_replace('DC$','Dendritic cells')%>%
        stringr::str_replace(fixed('CD8 T-cells'),'CD8 T cells')%>%
        stringr::str_replace('^NK$','NK cells')%>%
        stringr::str_replace(fixed('B cells naive'),'Naive B cells')%>%
        stringr::str_replace(fixed('B cells memory'),'Memory B cells')%>%
        stringr::str_replace(fixed('T cells CD4 naive'),'CD4 T cells naive')%>%
        stringr::str_replace(fixed('T cells CD4 memory activated'),'CD4 memory T cells activated')|>
      stringr::str_replace(fixed('T cells CD4 memory resting'),'CD4 memory T cells resting')
    

    ##massive if-else clause to match cell types :-/
    if(sig.mat=='LM9.txt'){
        #can only convert to LM9 or LM7c or PBMC
        if(sim.type=='prot'){
            ##just rename
        }else if(sim.type=='mrna'){
            #do nothing
        }else if(sim.type=='pbmc'){
            cell.type['CD4 T cells',]<-cell.type['CD4 naive T cells',]+
                cell.type['CD4 memory T cells resting',]+
                cell.type['CD4 memory T cells activated',]
            cell.type['B cells',]<-cell.type['Naive B cells',]+
                cell.type['Memory B cells',]
        }
    }else if(sig.mat=='LM22.txt'){
        #can convert to any other
        if(sim.type=='prot'){
            ##fix  t8 cells
            deconv.mat['B cells',]<-deconv.mat['Naive B cells',]+
                deconv.mat['Memory B cells',]
            deconv.mat['CD4 T cells',]<- deconv.mat['CD4 naive T-cells',]+
                deconv.mat['CD4 memory T-cells activated',]+
                deconv.mat['CD4 memory T-cells resting',]
            deconv.mat['NK cells',]<-deconv.mat['NK cells activated',]+
                deconv.mat['NK cells resting',]
            deconv.mat['Dendritic cells',]<-deconv.mat['Dendritic cells activated',]+
                deconv.mat['Dendritic cells resting',]

        }else if(sim.type=='mrna'){
          deconv.mat['B cells',]<-deconv.mat['Naive B cells',]+
            deconv.mat['Memory B cells',]
          deconv.mat['CD4 T cells',]<- deconv.mat['CD4 naive T cells',]+
            deconv.mat['CD4 memory T cells activated',]+
            deconv.mat['CD4 memory T cells resting',]
                          deconv.mat['T cells CD4 memory resting',]
            deconv.mat['NK cells',]<-deconv.mat['NK cells activated',]+
                deconv.mat['NK cells resting',]
        }else if(sim.type=='pbmc'){

            deconv.mat['NK cells',]<-deconv.mat['NK cells resting',]+
                deconv.mat['NK cells activated',]
        }
    }else if(sig.mat=='LM7c.txt'){
        #can not convert
        if(sim.type=='prot'){
            cell.type['Granulocytes',] <-cell.type['Neutrophils',]+
                cell.type['Eosinophils',]+
                cell.type['Basophil',]
        }else if(sim.type=='mrna'){
            #do nothing
        }else if(sim.type=='pbmc'){
             cell.type['CD4 T cells',]<-cell.type['CD4 naive T cells',]+
                cell.type['CD4 memory T cells resting',]+
                cell.type['CD4 memory T cells activated',]
            cell.type['B cells',]<-cell.type['Naive B cells',]+
                cell.type['Memory B cells',]

        }
    }else if(sig.mat=='pbmc.txt'){
        #can only covert to LM7c
        if(sim.type=='prot'){
            #do nothing
        }else if(sim.type=='mrna'){
                                        #do nothing
        }else if(sim.type=='pbmc'){
            cell.type['CD4 T cells',]<-cell.type['CD4 naive T cells',]+
                cell.type['CD4 memory T cells resting',]+
                cell.type['CD4 memory T cells activated',]

            cell.type['B cells',]<-cell.type['Naive B cells',]+
                cell.type['Memory B cells',]



        }
    }
    over <- intersect(rownames(deconv.mat),rownames(cell.type))
    print(paste0('Sig cell types: ',paste(rownames(deconv.mat),collapse=',')))
    print(paste0('Simulated cell types: ',paste(rownames(cell.type),collapse=',')))
    print(paste0('Overlapping cell types after mapping ',sig.mat,' to ',
                 sim.type,'(',length(over),'): ',paste(over,collapse=',')))

    write.table(deconv.mat,file='fixedDeconv.tsv',sep='\t',row.names=T,col.names=T)
    write.table(cell.type,file='fixedCells.tsv',sep='\t',row.names=T,col.names=T)
}

main()
