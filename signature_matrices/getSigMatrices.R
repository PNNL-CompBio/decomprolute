main<-function(){
    argv <- commandArgs(trailingOnly = TRUE)
    sig_name <- argv[1]
    file.copy(paste0("/",sig_name,".txt"), paste0("./",sig_name,".txt"))
}

main()
