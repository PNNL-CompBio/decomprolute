main <- function(){
    argv <- commandArgs(trailingOnly = TRUE)
    deconv.mat <- read.table(argv[1],header=T,row.names=1,sep='\t') #matrix to be fixed
    sig.mat <- argv[2] #signature used to deconvolve matrix
    sim.type <- argv[3] #type of simulation performed

    if(sig.mat=='LM9.txt')
    write.table(deconv.mat,file='fixed.tsv',sep='\t')
}

main()
