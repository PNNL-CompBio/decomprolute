main <- function(){
    argv <- commandArgs(trailingOnly = TRUE)
    deconv.mat <- read.table(argv[1],header=T,row.names=1,sep='\t') #matrix to be fixed
    sig.mat <- argv[2] #signature used to deconvolve matrix
    sim.type <- argv[3] #type of simulation performed
    sig.mat<-basename(sig.mat)
    
    if(sig.mat=='LM9.txt'){
        
    }else if(sig.mat=='LM22.txt'){
        
    }else if(sig.mat=='LM7c.txt'){
        
    }else if(sig.mat=='PBMC'){
        
    }
    
    write.table(deconv.mat,file='fixed.tsv',sep='\t')
}

main()
