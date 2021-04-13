require(argparser)

cell.types <- list(LM7c=c(' B cells','T4 cells','T8 cells','DC','Granulocytes','MO','NK cells'),
                   PBMC=c('B cells','Monocytes','T cells CD4','T cells CD8','NK T cells','Dendritic cells','NK cells','Megakaryocytes'),
                   LM9=c('B cells','T4 cells','T8 cells','DC','Basophil','Eosinophil','Neutrophil','MO','NK'),
                   LM22=c('B cells naive','B cells memory','Plasma cells','T cells CD8','T cells CD4 naive','T cells CD4 memory restring','T cells CD4 memory actiated','T cells follicular helping','T cells regulatory (Tregs)','T cells gamma delta','NK cells resting','NK cells activated','Monocytes','Macrophages M0','Macrophages M1','Eosinophils','Neutrophils'))

fix.mat <- function(mat.file,sig.file){
    sig <- read.table(sig.file)
    mat <- read.table(mat.file}

#   print(colnames(sig))
    print(colnames(mat))
    if(colnames(mat)==setdiff(colnames(sig),'gene')){
        print("No mapping needed, returning matrix")
        return(mat)
    }else if(length(colnames(sig))>length(colnames(mat))){
        print("Cannot map from fewer to greater cell types")
        return(mat)
    }else
}


main <- function(){
    argv <-commandArgs(trailingOnly=TRUE)
    mat.file = argv[1]
    eval.file = argv[2]
    signame = unlist(strsplit(basename(sig.file),split='.',fixed=T))[1]
    new.mat <- fix.mat(mat.file, signame)
}
