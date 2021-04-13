#' merge results across matrices, algorithms and cancers
#' currently we have two assessments:
#' 1 - assess correlations for each patient/disease
#' 2- assess correlations for each celltype/matrix
#'
#'
#' to run:
#' Rscript  combine_results.R --metricType sample --metric correlation */*corr.tsv
#' Rscript  combine_results.R --metricType cellType --metric correlation  */*corrXcelltypes.tsv
#' Rscript  combine_results.R --metricType js --metric distance */*dist.tsv

library(dplyr)
library(argparser)
library(ggplot2)

#' combine list of files of patient correlations
combinePatientCors<-function(file.list,metric='correlation'){
   message(paste0('Combining ',length(file.list),' files'))

   full.tab<-do.call(rbind,lapply(file.list,function(file){
      vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
      tissue=vars[1]
      disease=vars[2]
      mrna.algorithm=vars[3]
      prot.algorithm=vars[5]
      matrix=vars[6]
      tab<-read.table(file,fill=TRUE,check.names=FALSE)
      if (ncol(tab) > 1) {
        colnames(tab)<-(c('patient',metric))
      } else {
        tab$values <- NaN
        colnames(tab)<-(c('patient',metric))
      }
      return(data.frame(tab,tissue,disease,mrna.algorithm,prot.algorithm,matrix))
   }))
   full.tab<-full.tab%>%
       mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))

   mats<-unique(full.tab$matrix)
   lapply(mats,function(mat){
       p<-full.tab%>%
          rename(value=metric)%>%
           subset(matrix==mat)%>%
           ggplot()+
           geom_violin(aes(x=tissue,y=value,fill=disease))+
          facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+
          scale_fill_viridis_d()+
           theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
       ggsave(paste0(mat,'patient',metric,'s.pdf'),p,width=12,height=12)
   })

   p2<-full.tab%>%
     rename(value=metric)%>%
     ggplot(aes(x=matrix,y=value,fill=disease))+geom_violin()+
     facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_viridis_d()
   ggsave(paste0('allSigsPatient',metric,'.pdf'),p2,width=12,height=12)

   mean.tab<-full.tab%>%
     rename(value=metric)%>%
     group_by(tissue,disease,mrna.algorithm,prot.algorithm,matrix)%>%
          summarize(meanVal=mean(value,na.rm=T))

   p3<-ggplot(mean.tab,aes(x=matrix,shape=tissue,y=meanVal,col=disease))+geom_jitter()+
     facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_color_viridis_d()
   ggsave(paste0('patient',metric,'averages.pdf'),p2,width=12,height=12)

  return(full.tab)
}




#' combine list of files by cell type correlations
combineCellTypeCors<-function(file.list,metric='correlation'){
  message(paste0('Combining ',length(file.list),' files'))
  full.tab<-do.call(rbind,lapply(file.list,function(file){
      vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
      tissue=vars[1]
      disease=vars[2]
      mrna.algorithm=vars[3]
      prot.algorithm=vars[5]
      matrix=vars[6]
      tab<-read.table(file,fill=TRUE,sep='\t',check.names=FALSE)
      if (ncol(tab) > 1) {
        colnames(tab)<-(c('cellType',metric))
      } else {
        tab$values <- NaN
        colnames(tab)<-(c('cellType',metric))
      }
      return(data.frame(tab,tissue,disease,mrna.algorithm,prot.algorithm,matrix))

  }))

  full.tab<-full.tab%>%
      mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))%>%
    rename(value=metric)

  mats<-unique(full.tab$matrix)
#  require(cowplot)

  lapply(mats,function(mat){
      ft<-full.tab%>%subset(matrix==mat)

     ft$cellType<-factor(ft$cellType)
     p<-ggplot(ft)+geom_jitter(aes(x=cellType,y=value,size=10,color=disease,shape=tissue))+
       scale_color_viridis_d()+facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+
       theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
               ggtitle(mat)
      ggsave(paste0(mat,'cellType',metric,'s.pdf'),p,width=12,height=12)

   })
  p2<-ggplot(full.tab,aes(x=matrix,y=value,fill=cellType))+geom_violin()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_viridis_d()
  ggsave(paste0('allSigsCellType',metric,'.pdf'),p2,width=1,height=12)
   #p<-cowplot::plot_grid(plotlist=plist)

  mean.tab<-full.tab%>%group_by(tissue,disease,mrna.algorithm,prot.algorithm,matrix)%>%
    summarize(meanVal=mean(value,na.rm=T))

  p3<-ggplot(mean.tab,aes(x=matrix,shape=tissue,y=meanVal,col=disease))+geom_jitter()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_color_viridis_d()
  ggsave(paste0('cellType',metric,'averages.pdf'),p2,width=12,height=12)

   return(full.tab)
}


#' combine list of files of patient correlations
combineDists<-function(file.list,metric='distance', metricType='js'){
   message(paste0('Combining ',length(file.list),' files'))

   full.tab<-do.call(rbind,lapply(file.list,function(file){
      vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
      tissue=vars[1]
      disease=vars[2]
      mrna.algorithm=vars[3]
      prot.algorithm=vars[5]
      matrix=vars[6]
      tab<-read.table(file,fill=TRUE,check.names=FALSE)
      if (ncol(tab) > 1) {
        colnames(tab)<-(c('patient',metric))
        distance <- sqrt(sum(tab[[metric]]^2))
      } else {
        distance <- NaN
      }
      return(data.frame(distance,tissue,disease,mrna.algorithm,prot.algorithm,matrix))
   }))
   full.tab<-full.tab%>%
       mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))

   # mats<-unique(full.tab$matrix)
   # lapply(mats,function(mat){
   #   p<-full.tab%>%
   #     rename(value=metric)%>%
   #     subset(matrix==mat)%>%
   #     ggplot()+
   #     geom_violin(aes(x=tissue,y=value,fill=disease))+
   #     facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+
   #     scale_fill_viridis_d()+
   #     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
   #   ggsave(paste0(mat,'patient',metric,'s.pdf'),p,width=12,height=12)
   # })

   p2<-full.tab%>%
     rename(value=metric)%>%
     ggplot(aes(x = mrna.algorithm, y = prot.algorithm, fill = value)) + geom_tile() +
     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
     # ggplot(aes(x=matrix,y=value,fill=disease))+geom_violin()+
     facet_grid(rows=vars(matrix),cols=vars(disease))#+scale_fill_viridis_d()
   ggsave(paste0('heatmaps-', metricType, '-', metric,'.pdf'),p2,width=14,height=8)

   p3<-full.tab%>%
     rename(value=metric)%>%
     ggplot(aes(x=matrix,shape=tissue,y=value,col=disease))+geom_jitter()+
     facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_color_viridis_d() + ylab(metric)
   ggsave(paste0('scatters-', metricType, '-', metric,'.pdf'),p3,width=10,height=8)

  return(full.tab)
}




 main<-function(){

    ##todo: store in synapse
  argv <- commandArgs(trailingOnly = TRUE)
  file.list<-argv[3:length(argv)]
  metric=argv[2]
  metricType = argv[1]
  if(metric=='correlation' && metricType=='sample'){
    tab<-combinePatientCors(file.list,metric)
    print(dim(tab))
    write.table(tab,paste0('combined-', metricType, '-', metric,'.tsv'),row.names=F,col.names=T)
  }else if(metric=='correlation' && metricType=='cellType'){
    tab<-combineCellTypeCors(file.list,metric)
    print(dim(tab))
    write.table(tab,paste0('combined-', metricType, '-', metric,'.tsv'),row.names=F,col.names=T)
  }else if(metric=='distance'){
    tab<-combineDists(file.list,metric,metricType)
    print(dim(tab))
    write.table(tab,paste0('combined-', metricType, '-', metric,'.tsv'),row.names=F,col.names=T)
  }else{
    print("First argument must be metricType and second must be metric name")

  }

}

main()
