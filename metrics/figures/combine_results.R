#' merge results across matrices, algorithms and cancers
#' currently we have two assessments:
#' 1 - assess correlations for each patient/disease
#' 2- assess correlations for each celltype/matrix
#'
#' We generally only use correlation right now
#' to run:
#' Rscript  combine_results.R --metricType sample --metric correlation --repNumber 0 */*corr.tsv
#' Rscript  combine_results.R --metricType cellType --metric correlation  --repNumber 0  */*corrXcelltypes.tsv
#' Rscript  combine_results.R --metricType sample --metric meanCorrelation  --repNumber 0 */*corr.tsv
#' Rscript  combine_results.R --metricType cellType --metric meanCorrelation  --repNumber 0  */*corrXcelltypes.tsv
#' Rscript  combine_results.R --metricType js --metric distance  --repNumber 0  */*dist.tsv

library(dplyr)
library(argparser)
library(ggplot2)
library(nationalparkcolors)
# pal<-c(park_palette('GeneralGrant'), park_palette('Redwoods'))

##here is the color scheme
pal <- unlist(park_palettes[c(7, 15, 25, 22, 19, 16, 13, 11, 12, 3, 1, 2, 4, 5, 6, 8, 9, 10, 14, 17, 18, 20, 21, 23, 24)], use.names = F)


###combineResultsFiles
## this is an important function that is used by all figure files
## combines all ersults into a single file
combineResultsFiles<-function(file.list,colnamevals=c('patient','correlation')){
  
  message(paste0('Combining ',length(file.list),' files'))
  
  ##first we read in each file and make int a single table
  full.tab<-do.call(rbind,lapply(file.list,function(file){
    vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
    tissue=vars[1]
    disease=vars[2]
    mrna.algorithm=vars[3]
    prot.algorithm=vars[5]
    matrix=vars[6]
    sample=vars[7]
    rep = vars[9]
    tab<-read.table(file,fill=TRUE,sep = '\t',check.names=FALSE)
    
    ##here we have to do some tomfoolery
    if (ncol(tab) > 1) {
      colnames(tab)<-colnamevals
    } else {
      tab$values <- NaN
      colnames(tab)<-colnamevals
    }
    return(data.frame(tab,tissue,disease,mrna.algorithm,prot.algorithm,matrix,sample,rep))
  }))
  
  full.tab<-full.tab%>%
    mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))
  
  return(full.tab)
}


#' combine list of files of patient correlations
#' patient correlations represent how similar the cell type distribution is on a per-patient value, by cancer
combinePatientCors<-function(file.list,metric='correlation'){

  full.tab<-combineResultsFiles(file.list,colnamevals=c('patient',metric))|>
	dplyr::rename(value=metric)
  mats<-unique(full.tab$matrix)

  lapply(mats,function(mat){
    p<-full.tab%>%
      subset(matrix==mat)%>%
      ggplot()+
      geom_violin(aes(x=tissue,y=value,fill=disease))+
      facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+
      scale_fill_manual(values=pal)+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    ggsave(paste0(mat,'patient',metric,'s.pdf'),p,width=12,height=12)
  })

  p2<-full.tab%>%
    ggplot(aes(x=matrix,y=value,fill=disease))+geom_violin()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_manual(values=pal)
  ggsave(paste0('allSigsPatient',metric,'.pdf'),p2,width=12,height=12)

  mean.tab<-full.tab%>%
    group_by(tissue,disease,mrna.algorithm,prot.algorithm,matrix)%>%
    summarize(meanVal=mean(value,na.rm=T))

  p3<-ggplot(mean.tab,aes(x=matrix,shape=tissue,y=meanVal,col=disease))+geom_jitter()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_color_manual(values=pal)
  ggsave(paste0('patient',metric,'averages.pdf'),p2,width=12,height=12)

  return(full.tab)
}


#' combine list of files by cell type correlations
combineCellTypeCors<-function(file.list,metric='correlation'){
  
  full.tab<-combineResultsFiles(file.list,colnamevals=c('cellType',metric))|>
    dplyr::rename(value=metric)
  print(head(full.tab))
  
  mats<-unique(full.tab$matrix)
  #  require(cowplot)

  fc<-ggplot(full.tab,aes(x=cellType,y=value,fill=as.factor(sample)))+geom_boxplot()+facet_grid(algorithm~matrix)+scale_fill_manual(values=pal)+
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
  ggsave(paste0('cellType',metric,'AllSamples.pdf'),fc,width=10)
  
  lapply(mats,function(mat){
    ft<-full.tab%>%subset(matrix==mat)|>
      subset(sample==max(full.tab$sample))
    ft$cellType<-factor(ft$cellType)

    print(head(ft))
    p<-ggplot(ft)+geom_boxplot(aes(x=cellType,y=value,fill=mrna.algorithm))+
      scale_fill_manual(values=pal)+facet_grid(cols=vars(prot.algorithm),rows=vars(sample))+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
      ggtitle(mat)
    ggsave(paste0(mat,'cellType',metric,'sProtbp.pdf'),p,width=10)

    p<-ggplot(ft)+geom_boxplot(aes(x=cellType,y=value,fill=prot.algorithm))+
      scale_fill_manual(values=pal)+facet_grid(cols=vars(mrna.algorithm),rows=vars(sample))+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
      ggtitle(mat)
    ggsave(paste0(mat,'cellType',metric,'sMrnabp.pdf'),p,width=10)

    pa<-ggplot(ft)+geom_bar(aes(x=cellType,y=value,fill=as.factor(disease)),stat='identity',position='dodge')+
      facet_grid(cols=vars(prot.algorithm),rows=vars(mrna.algorithm))+scale_fill_manual(values=pal)+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
      ggtitle(mat)

    ggsave(paste0(mat,'cellType',metric,'sBars.pdf'),pa,width=10)
  })

  p1<-ggplot(full.tab,aes(x=matrix,y=value,fill=disease))+geom_boxplot()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_manual(values=pal)
  ggsave(paste0('allSigsDisease',metric,'.pdf'),p1,width=20,height=20)

  p2<-ggplot(full.tab,aes(x=matrix,y=value,fill=cellType))+geom_boxplot()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_manual(values=pal)+
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  ggsave(paste0('allSigsCellType',metric,'.pdf'),p2,width=20,height=20)

  p3<-ggplot(full.tab,aes(x=cellType,y=value,fill=matrix))+geom_boxplot()+
    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_fill_manual(values=pal)+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  ggsave(paste0('allSigsMatrix',metric,'.pdf'),p3,width=20,height=20)

  #p<-cowplot::plot_grid(plotlist=plist)

  mean.tab<-full.tab%>%group_by(tissue,disease,mrna.algorithm,prot.algorithm,matrix)%>%
    summarize(meanVal=mean(value,na.rm=T))

  p4<-ggplot(mean.tab,aes(x=matrix,y=meanVal,fill=prot.algorithm))+geom_boxplot()+
    facet_grid(cols=vars(mrna.algorithm))+scale_fill_manual(values=pal)
  ggsave(paste0('cellType',metric,'BoxplotMrna-averages.pdf'),p4)

  p5<-ggplot(mean.tab,aes(x=matrix,y=meanVal,fill=mrna.algorithm))+geom_boxplot()+
    facet_grid(cols=vars(prot.algorithm))+scale_fill_manual(values=pal)
  ggsave(paste0('cellType',metric,'BoxplotProt-averages.pdf'),p5)

  p6<-mean.tab%>%
      ggplot(aes(x = mrna.algorithm, y = prot.algorithm, fill = meanVal)) + geom_tile(height=1,width=1) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
                                        # ggplot(aes(x=matrix,y=value,fill=disease))+geo_violin()+
      facet_grid(rows=vars(matrix),cols=vars(disease))+scale_fill_gradient(low=pal[1],high=pal[3])
  ggsave(paste0('heatmaps-', metric, 'averages.pdf'),p6)


  return(full.tab)
}

#' combine list of files of patient mean correlations
combineCorsMean<-function(file.list,metric='meanCorrelation', metricType='patient'){
  
  full.tab<-combineResultsFiles(file.list,colnamevals = c(metricType,'correlation'))
  
  full.tab<-full.tab|>
    dplyr::rename(newMet=metric)|>
    group_by(tissue,disease,mrna.algorithm,prot.algorithm,matrix,sample)|>
    summarize(meanCorr=mean(newMet))
  
  # message(paste0('Combining ',length(file.list),' files'))
  # 
  # full.tab<-do.call(rbind,lapply(file.list,function(file){
  #   vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
  #   tissue=vars[1]
  #   disease=vars[2]
  #   mrna.algorithm=vars[3]
  #   prot.algorithm=vars[5]
  #   matrix=vars[6]
  #   sample=vars[7]
  #   tab<-read.table(file,fill=TRUE, sep = '\t',check.names=FALSE)
  #   if (ncol(tab) > 1) {
  #     colnames(tab)<-(c(metricType,metric))
  #     meanCorr <- mean(tab[[metric]])
  #   } else {
  #     meanCorr <- NaN
  #   }
  #   return(data.frame(meanCorr,tissue,disease,mrna.algorithm,prot.algorithm,matrix,sample))
  # }))
  # full.tab<-full.tab%>%
  #   mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))
  # 
 
  p2<-full.tab%>%
    ggplot(aes(x = mrna.algorithm, y = prot.algorithm, fill = meanCorr)) + geom_tile() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    # ggplot(aes(x=matrix,y=value,fill=disease))+geom_violin()+
    facet_grid(rows=vars(matrix),cols=vars(disease))+scale_fill_viridis_c()
  ggsave(paste0('heatmaps-', metricType, '-', metric,'.pdf'),p2)

#  p3<-full.tab%>%
#    ggplot(aes(x=matrix,shape=tissue,y=meanCorr,col=disease))+geom_jitter()+
#    facet_grid(rows=vars(mrna.algorithm),cols=vars(prot.algorithm))+scale_color_viridis_d() + ylab(metric)
#  ggsave(paste0('scatters-', metricType, '-', metric,'.pdf'),p3)

  p4<-full.tab%>%
    ggplot(aes(x=disease,y=meanCorr,fill=matrix))+geom_bar(stat='identity',position='dodge')+
    facet_grid(cols=vars(prot.algorithm),rows=vars(mrna.algorithm))+scale_fill_viridis_d()
  ggsave(paste0('barplot-matrix-', metricType, '-', metric,'.pdf'),p4,width=20)

  p5<-full.tab%>%
    ggplot(aes(x=matrix,y=meanCorr,fill=disease))+geom_bar(stat='identity',position='dodge')+
    facet_grid(cols=vars(prot.algorithm),rows=vars(mrna.algorithm))+scale_fill_viridis_d()
  ggsave(paste0('barplot-disease-', metricType, '-', metric,'.pdf'),p5,width=20)

  return(full.tab)
}

#' combine list of files of patient distances
combineDists<-function(file.list,metric='distance', metricType='js'){
 
  full.tab<-combineResultsFiles(file.list,colnamevals = c(metricType,'correlation'))
  full.tab<-full.tab|>
    dplyr::rename(newMet=metric)|>
    group_by(tissue,disease,mrna.algorithm,prot.algorithm,matrix,sample)|>
    summarize(distance=mean(newMet))
  
  # message(paste0('Combining ',length(file.list),' files'))
  # 
  # full.tab<-do.call(rbind,lapply(file.list,function(file){
  #   vars <- unlist(strsplit(basename(file),split='-')) #split into pieces
  #   tissue=vars[1]
  #   disease=vars[2]
  #   mrna.algorithm=vars[3]
  #   prot.algorithm=vars[5]
  #   matrix=vars[6]
  #   sample=vars[7]
  #   tab <- NULL
  # 
  #   try(tab<-read.table(file,fill=TRUE,sep = '\t', check.names=FALSE))
  #   if(is.null(tab))
  #     return(NULL)
  #   if (ncol(tab) > 1) {
  #     colnames(tab)<-(c('patient',metric))
  #     distance <- mean(tab[[metric]])
  #   } else {
  #     distance <- NaN
  #   }
  #   return(data.frame(distance,tissue,disease,mrna.algorithm,prot.algorithm,matrix,sample))
  # }))
  # full.tab<-full.tab%>%
  #   mutate(algorithm=paste(mrna.algorithm,prot.algorithm,sep='-'))

  p2<-full.tab%>%
    ggplot(aes(x = mrna.algorithm, y = prot.algorithm, fill = distance)) + geom_tile(height=1,width=1) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    # ggplot(aes(x=matrix,y=value,fill=disease))+geo_violin()+
    facet_grid(rows=vars(matrix),cols=vars(disease))+scale_fill_gradient(low=pal[1],high=pal[3])
  ggsave(paste0('heatmaps-', metricType, '-', metric,'.pdf'),p2)

  p4<-full.tab%>%
    ggplot(aes(x=disease,y=distance,fill=matrix))+geom_bar(stat='identity',position='dodge')+
    facet_grid(cols=vars(prot.algorithm),rows=vars(mrna.algorithm))+scale_fill_manual(values=pal)+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))#+scale_fill_viridis_d()
  ggsave(paste0('barplot-matrix-', metricType, '-', metric,'.pdf'),p4)


  p5<-full.tab%>%
    ggplot(aes(x=matrix,y=distance,fill=as.factor(disease)))+geom_bar(stat='identity',position='dodge')+
    facet_grid(cols=vars(prot.algorithm),rows=vars(mrna.algorithm))+scale_fill_manual(values=pal)#+scale_fill_viridis_d()
  ggsave(paste0('barplot-disease-', metricType, '-', metric,'.pdf'),p5)


  p5<-full.tab%>%
    ggplot(aes(x=matrix,y=distance,fill=mrna.algorithm))+geom_boxplot()+
    facet_grid(cols=vars(prot.algorithm))+scale_fill_manual(values=pal)#+scale_fill_viridis_d()
  ggsave(paste0('boxplot-disease-', metricType, '-', metric,'mrna.pdf'),p5)

  p5<-full.tab%>%
    ggplot(aes(x=matrix,y=distance,fill=prot.algorithm))+geom_boxplot()+
    facet_grid(cols=vars(mrna.algorithm))+scale_fill_manual(values=pal)#+scale_fill_viridis_d()
  ggsave(paste0('boxplot-disease-', metricType, '-', metric,'prot.pdf'),p5)

  return(full.tab)
}




main<-function(){

  ##todo: store in synapse
  argv <- commandArgs(trailingOnly = TRUE)
  file.list<-argv[4:length(argv)]
  metric=argv[2]
  metricType = argv[1]
  repNumber = argv[3]
  if(metric=='correlation' && metricType=='sample'){
    tab<-combinePatientCors(file.list,metric)
    print(dim(tab))
    write.table(tab,paste0('combined-', metricType, '-', metric,'-',repNumber,'.tsv'),row.names=F,col.names=T)
  }else if(metric=='correlation' && metricType=='cellType'){
    tab<-combineCellTypeCors(file.list,metric)
    print(dim(tab))
    write.table(tab,paste0('combined-', metricType, '-', metric,'-',repNumber,'.tsv'),row.names=F,col.names=T)
  } else if (metric=='meanCorrelation'){
    tab<-combineCorsMean(file.list,metric, metricType)
    print(dim(tab))
    write.table(tab,paste0('combined-', metricType, '-', metric,'-',repNumber,'.tsv'),row.names=F,col.names=T)
  }else if(metric=='distance'){
    tab<-combineDists(file.list,metric,metricType)
    print(dim(tab))
    write.table(tab,paste0('combined-', metricType, '-', metric,'-',repNumber,'.tsv'),row.names=F,col.names=T)
  }else{
    print("First argument must be metricType and second must be metric name")

  }

}

main()
