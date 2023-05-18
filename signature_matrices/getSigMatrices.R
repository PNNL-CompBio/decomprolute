library(readxl)
library(tidyr)
library(dplyr)
library(tibble)
main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)
    sig_name <- trimws(argv[1])
    # if(tolower(sig_name)=='aml'){
    #   ###get AML Signature
    #   tab <- readxl::read_xlsx('/aml_vanGalen_cellTypes.xlsx',skip=1)[,-c(1,10,14)]
    #   colnames(tab)<-paste(c(rep('Normal-Combined',3),rep('Tumor-combined',3),rep('Tumor-celltype',5)),
    #                        gsub('...6','',colnames(tab)))
    #   tab<-tab[1:50,]
    #   tab$LSC17=c('DNMT3B','ZBTB46','NYNRIN','ARHGAP22','LAPTM4B','MMRN1','DPYSL3','KIAA0125','CDK6','CPXM1','GPR56','AKR1C3','CD34','NGFRAP1','EMP1','SMIM24','SOCS2',rep('',33))
    #   tab<-tab%>%
    #     pivot_longer(cols=c(1:ncol(tab)),names_to='cellType',values_to='gene')%>%
    #     mutate(value=1)%>%
    #     pivot_wider(names_from=cellType,values_fill=0,values_fn=mean)%>%
    #     tibble::column_to_rownames("gene")
    #   
    #   write.table(tab,'./AML.txt',row.names=T,sep='\t',quote=F)
    # 
    # }
    #else 
    if(tolower(sig_name)=='matrisome'){
      tab <- readxl::read_xlsx('/Hs_Matrisome_Masterlist_Naba et al_2012.xlsx')[,c(2:3)]|>
        mutate(value=1.0)|>
        tidyr::pivot_wider(names_from='Category',values_from='value',values_fill=0.001)|>
        tibble::column_to_rownames('Gene Symbol')
        
      write.table(tab,'./Matrisome.txt',row.names=T,sep='\t',quote=F)
      
    }
    else
      file.copy(paste0("/",sig_name,".txt"), paste0("./",sig_name,".txt"))
}

main()
