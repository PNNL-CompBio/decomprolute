library(readxl)
library(tidyr)
library(dplyr)
library(tibble)

main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)
    sig_name <- trimws(argv[1])

    sample <-as.numeric(trimws(argv[2]))
    print(sample)    
    #reshape matrisome to adhere to standards
    if(tolower(sig_name)=='matrisome'){
      tab <- readxl::read_xlsx('/Hs_Matrisome_Masterlist_Naba et al_2012.xlsx')[,c(2:3)]|>
        mutate(value=1.0)|>
        tidyr::pivot_wider(names_from='Category',values_from='value',values_fill=0.001)|>
        tibble::column_to_rownames('Gene Symbol')
        
      write.table(tab,'./Matrisome.txt',row.names=T,sep='\t',quote=F)
      
    }
    
    if(as.numeric(sample)<100){
    	print('providing sampled signature matrix')
	tab <- read.table(paste0('/',sig_name,'.txt'),header=T,sep='\t',row.names=1,check.names=F)
	num<-nrow(tab)
	prots<-rownames(tab)
	subsamp<-sample(prots,size=round(length(prots)*sample/100),replace=FALSE)
	print(paste('reducing signature matrix from',nrow(tab),'to',length(subsamp)))
	tab<-tab[subsamp,]
	sig_name <- paste0(sig_name,'_',sample)
	write.table(tab,paste0('./',sig_name,'.txt'),row.names=T,sep='\t',quote=F)
    }else{
        file.copy(paste0("./",sig_name,".txt"), paste0("./",sig_name,'_',sample,".txt"))

    }
}

main()
