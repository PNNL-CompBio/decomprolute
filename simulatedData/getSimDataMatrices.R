require(argparser)

dataToTxt<-function(dobj){
  load(dobj)
  matname=gsub('.rda','_matrix.tsv',basename(dobj))
  cellname=gsub('.rda','_cellPreds.tsv',basename(dobj))
  write.table(data.mix,file=matname,sep='\t',quote=FALSE,row.names=TRUE,col.names=TRUE)
  pi<-t(pi)
  colnames(pi)<-colnames(data.mix)
  rownames(pi)<-sapply(rownames(pi),function(x) ifelse(x%in%c("T4","T8"),paste(x,'cells'),x))

  write.table(pi,file=cellname,sep='\t',quote=FALSE,row.names=TRUE,col.names=TRUE)
}



main<-function(){
  argv <- commandArgs(trailingOnly = TRUE)

  files = c('data_rep_1.rda','data_rep_2.rda','data_rep_3.rda','data_rep_4.rda','data_rep_5.rda')
  #if(argv[1]=='getData'){
  datarep=argv[1]
  if(!datarep%in%c('1','2','3','4','5')){
    print(paste0('No data file for',datarep))
  }else{
      dataToTxt(paste0('/bin/data_rep_',datarep,'.rda'))
  }
}

main()
