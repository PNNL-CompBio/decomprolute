require(argparser)

dataToTxt<-function(dobj){
    load(dobj)
    matname=gsub('.rda','_matrix.tsv',basename(dobj))
    cellname=gsub('.rda','_cellPreds.tsv',basename(dobj))
    pi<-t(pi)
    colnames(pi)<-colnames(data.mix)

    data.mix<-data.frame(Genes=rownames(data.mix),data.mix)
    write.table(data.mix,file=matname,sep='\t',quote=FALSE,row.names=FALSE,col.names=TRUE)
    rownames(pi)<-sapply(rownames(pi),function(x) ifelse(x%in%c("T4","T8"),paste(x,'cells'),x))
    write.table(pi,file=cellname,sep='\t',quote=FALSE,row.names=TRUE,col.names=TRUE)
}



main<-function(){
  argv <- commandArgs(trailingOnly = TRUE)

  #files = c('data_rep_1.rda','data_rep_2.rda','data_rep_3.rda','data_rep_4.rda','data_rep_5.rda')
  #gsefiles = paste0('gse60424_',c(1:10),'.rda')
  pbmc = 'pbmc_data_mix.rda'
  #if(argv[1]=='getData'){
  simdata = argv[1]
  if(simdata=='pbmc')
    dataToTxt(paste0('/bin/',pbmc))
  else{
    datarep=argv[2]
    if(simdata=='prot'){
      if(datarep%in%c('1','2','3','4','5')){
        print(paste0('No proteomics data file for',datarep))
      }else{
        dataToTxt(paste0('/bin/data_rep_',datarep,'.rda'))
      }
    }else if(simdata=='rna'){
      if(datarep%in%c('1','2','3','4','5','6','7','8','9','10')){
        print(paste0('No rna data file for',datarep))
      }else{
        dataToTxt(paste0('/bin/gse60424_',datarep,'.rda'))
      }
      
    }
  }
  
}

main()
