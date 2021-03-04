#' merge results across matrices, algorithms and cancers
#' currently we have two assessments:
#' 1 - assess correlations for each patient/disease
#' 2- assess correlations for each celltype/matrix
#'
#'
#' to run:
#' Rscript  combine_results.R --sample */*corr.tsv
#' Rscript  combine_results.R --cellType  */*corrXcelltypes.tsv

library(dplyr)
library(argparser)
library(ggplot2)

#' combine list of files of patient correlations
combinePatientCors<-function(file.list){
   message(paste0('Combining ',length(file.list),' files'))

   full.tab<-do.call(rbind,lapply(file.list,function(file){
      vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
      tissue=vars[1]
      disease=vars[2]
      mrna.algorithm=vars[3]
      prot.algorithm=vars[5]
      matrix=vars[6]
      tab<-read.table(file,fill=TRUE)
      colnames(tab)<-(c('patient','correlation'))
      return(data.frame(tab,tissue,disease,mrna.algorithm,prot.algorithm,matrix))
   }))
   full.tab<-full.tab%>%
       mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))

   mats<-unique(full.tab$matrix)
   lapply(mats,function(mat){
       p<-full.tab%>%
           subset(matrix==mat)%>%
           ggplot()+
           geom_violin(aes(x=tissue,y=correlation,fill=disease))+
          facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+
          scale_fill_viridis_d()+
           theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
       ggsave(paste0(mat,'patientCors.pdf'),p,width=12,height=12)
   })

   p2<-ggplot(full.tab,aes(x=matrix,y=correlation,fill=disease))+geom_violin()+
     facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_viridis_d()
   ggsave('allSigsPatientCors.pdf',p2,width=12,height=12)
  return(full.tab)
}



#' combine list of files by cell type correlations
combineCellTypeCors<-function(file.list){
  message(paste0('Combining ',length(file.list),' files'))
  full.tab<-do.call(rbind,lapply(file.list,function(file){
      vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
      tissue=vars[1]
      disease=vars[2]
      mrna.algorithm=vars[3]
      prot.algorithm=vars[5]
      matrix=vars[6]
      tab<-read.table(file,fill=TRUE,sep='\t')
      colnames(tab)<-(c('cellType','correlation'))
      return(data.frame(tab,tissue,disease,mrna.algorithm,prot.algorithm,matrix))

  }))

  full.tab<-full.tab%>%
      mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))

  mats<-unique(full.tab$matrix)
#  require(cowplot)

  lapply(mats,function(mat){
      ft<-full.tab%>%subset(matrix==mat)

     ft$cellType<-factor(ft$cellType)
     p<-ggplot(ft)+geom_jitter(aes(x=cellType,y=correlation,size=10,color=disease,shape=tissue))+
       scale_color_viridis_d()+facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+
       theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
               ggtitle(mat)
      ggsave(paste0(mat,'cellTypeCors.pdf'),p,width=12,height=12)
 
   })
  p2<-ggplot(full.tab,aes(x=matrix,y=correlation,fill=cellType))+geom_violin()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_viridis_d()
  ggsave('allSigsCellTypeCors.pdf',p2,width=1,height=12)
   #p<-cowplot::plot_grid(plotlist=plist)
   return(full.tab)
}




 main<-function(){

    ##todo: store in synapse
  argv <- commandArgs(trailingOnly = TRUE)
  file.list<-argv[2:length(argv)]

  if(argv[1]=='sample'){
    tab<-combinePatientCors(file.list)
    print(dim(tab))
    write.table(tab,'combinedSampleCorrelationTab.tsv',row.names=F,col.names=T)
  }else if(argv[1]=='cellType'){
    tab<-combineCellTypeCors(file.list)
    print(dim(tab))
    write.table(tab,'combinedCellTypeCorrelationTab.tsv',row.names=F,col.names=T)
  }else{
    print("First argument must be `cellType` or `sample`")

  }
}

main()
