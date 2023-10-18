library(readxl)
library(tidyr)
library(dplyr)
library(tibble)

main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)
    sig_name <- trimws(argv[1])

    sampval <-as.numeric(trimws(argv[2]))
    print(sampval)    
    #reshape matrisome to adhere to standards

    print('providing sampled signature matrix')
    tab <- read.table(paste0('/',sig_name,'.txt'),header=T,sep='\t',row.names=1,check.names=F)
    num<-nrow(tab)
    prots<-rownames(tab)
    subsamp<-sample(prots,size=round(length(prots)*sampval/100),replace=FALSE)
    print(paste('reducing signature matrix from',nrow(tab),'to',length(subsamp)))
    tab<-tab[subsamp,]
    sig_name <- paste0(sig_name,'_',sampval)
    write.table(tab,paste0('./',sig_name,'.txt'),row.names=T,sep='\t',quote=F)

}

main()
