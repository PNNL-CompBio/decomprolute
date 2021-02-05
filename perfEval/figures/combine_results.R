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
      disease=vars[1]
      mrna.algorithm=vars[2]
      prot.algorithm=vars[4]
      matrix=vars[5]
      tab<-read.table(file,fill=TRUE)
      colnames(tab)<-(c('patient','correlation'))
      return(data.frame(tab,disease,mrna.algorithm,prot.algorithm,matrix))
  }))

   full.tab<-full.tab%>%mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))


   mats <- unique(full.tab$matrix)
   for(m in mats){
       p <- full.tab%>%subset(matrix==m)%>%
           ggplot()+
           geom_violin(aes(x=prot.algorithm,y=correlation,fill=disease))+
           facet_grid(mrna.algorithm~.)+scale_fill_viridis_d()+
           theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
       ggsave(paste0(m,'patientCors.pdf'),p,width=11,height=10)
   }
     return(full.tab)}



#' combine list of files by cell type correlations
combineCellTypeCors<-function(file.list){
  message(paste0('Combining ',length(file.list),' files'))
   full.tab<-do.call(rbind,lapply(file.list,function(file){
      vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
      disease=vars[1]
      mrna.algorithm=vars[2]
      prot.algorithm=vars[4]
      matrix=vars[5]
      tab<-read.table(file,fill=TRUE,sep='\t')
      colnames(tab)<-(c('cellType','correlation'))
      return(data.frame(tab,disease,mrna.algorithm,prot.algorithm,matrix))

  }))

  full.tab<-full.tab%>%mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))
  require(cowplot)

  mats <- unique(full.tab$matrix)
  for(mat in mats){
      ft<-full.tab%>%subset(matrix==mat)
      plist<-lapply(unique(ft$mrna.algorithm),function(m){
          stab<-subset(full.tab,mrna.algorithm==m)
          stab$cellType<-factor(stab$cellType)
          ggplot(stab)+geom_jitter(aes(x=cellType,y=correlation,color=prot.algorithm,shape=disease,size=10))+
              scale_color_viridis_d()+
              theme(text = element_text(size=20),axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
              ggtitle(m)
      })

       p<-cowplot::plot_grid(plotlist=plist)

       ggsave(paste0(mat,'cellTypeCors.pdf'),p,width=20,height=15)
   }
      return(full.tab)





 main<-function()}{

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



  ##plot



}

main()
