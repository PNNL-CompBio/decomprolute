## takes the files from francesca and formats them into a usable format for github/docker


load('GSE60424_poisson_plus_noise.rda')

mix.list <- data.mix
pbmc.cyt<-read.table('PBMCs-Fig3a-Flow-Cytometry.txt',sep='\t',header=T,row.names=1,check.names = F)
pbmc.rna<-read.table("PBMCs-Fig3a-HumanHT-12-V4.txt",sep='\t',header=T,row.names=1,check.names=F)

##first save the poisson data in 10 separate files
for(i in 1:10){
  data.mix <- mix.list[[i]]
  sampnames<-paste0('sample',c(1:ncol(data.mix)))
  rownames(data.mix)<-geneID
  colnames(data.mix)<-sampnames
  rownames(pi)<-sampnames
  save(file=paste0('gse60424_',i,'.rda'),list=c('data.mix','pi'))
}

pi=pbmc.cyt
data.mix <- pbmc.rna
save(file='pbmc_data_mix.rda',list=c('data.mix','pi'))