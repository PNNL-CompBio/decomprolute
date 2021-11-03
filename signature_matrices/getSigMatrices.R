main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)

    matrix_name = tolower(argv[1])
    print(simdata)
                                        #if(simdata=='pbmc'){
                                        #  dataToTxt(paste0('/bin/pbmc_data_mix.rda'))
                                        #}else{
    datarep=argv[2]
    if(simdata=='prot'){
        if(!datarep%in%c('1','2','3','4','5')){
            print(paste0('No proteomics data file for',datarep))
        }else{
            dataToTxt(paste0('/bin/data_rep_',datarep,'.rda'))
        }
    }else if(simdata=='mrna'){
        if(!datarep%in%c('1','2','3','4','5','6','7','8','9','10','pbmc')){
            print(paste0('No rna data file for',datarep))
        }else if(datarep=='pbmc'){
            dataToTxt(paste0('/bin/pbmc_data_mix.rda'))
        }else{
            dataToTxt(paste0('/bin/gse60424_',datarep,'.rda'))
        }
    }


    main()}
