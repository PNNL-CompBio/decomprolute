# -- load function
source("/Users/anna/PycharmProjects/proteomicsTumorDeconv/francesca/function_bulk_repulsive_github.R")
load("/Users/anna/PycharmProjects/proteomicsTumorDeconv/francesca/Synthetic_example.rda")


# -- input
# args <- commandArgs(trailingOnly = TRUE)
# argsLen <- length(args)

# input_f_list_gene <- args[1]
# input_f_data <- args[2]
# n.iter<-args[3]
# burn.in<-args[4]

# input_f_list_gene <- "/Users/anna/PycharmProjects/proteomicsTumorDeconv/francesca/toy_list_gene.tsv"
# input_f_data <- "/Users/anna/PycharmProjects/proteomicsTumorDeconv/francesca/toy_data.tsv"
n.iter<-100
burn.in<-100
# 
# # input_f_list_gene is a tsv with cell types as the column names and rows
# list.gene = read.csv(input_f_list_gene, header=TRUE, row.names=1, sep = '\t')
# # input_f_data is a tsv with samples as the column names and rows as gene symbols
# data = read.csv(input_f_data, header=TRUE, row.names=1, sep = '\t')

#list.gene<- # -- list object containing list of key markers for each cell type with list[[k]] returning the list of key markers for cell type k
#data<- # - p x n matrix of expression profile (rownames = gene names)
k.fix<-length(list.gene)

# --- build index matrix
index.matrix<-c(NULL,NULL,NULL)
for (s in 2:k.fix){
  for (k in 1:(s-1)) {
    index.s<-c(NULL,NULL,NULL)
    mg<-match(list.gene[[s]],list.gene[[k]])
    gene<-list.gene[[s]][is.na(mg)]
    if (length(gene)>0) index.s<-rbind(index.s,cbind(rep(s,length(gene)),rep(k,length(gene)),gene))
    
    mg<-match(list.gene[[k]],list.gene[[s]])
    gene<-list.gene[[k]][is.na(mg)]
    if (length(gene)>0) index.s<-rbind(index.s,cbind(rep(k,length(gene)),rep(s,length(gene)),gene))
    
    index.matrix<-rbind(index.matrix,index.s)
  }
}

k.fix<-length(list.gene)
data<-t(apply(data,1,function(x)(x-mean(x))/sd(x)))
index.matrix<-apply(index.matrix,2,as.numeric)

gibbs<-gibbs.sampling(n.iter=n.iter,data,p=dim(data)[1],n=dim(data)[2],k.fix,index.matrix,burn.in,mean.prior=matrix(0,dim(data)[1],k.fix),sigma.prior=1)


# save gibbs object to rda file
write.table(gibbs[[1]][[1]],"sandbox_output_rep_bulk.tsv",row.names=TRUE, col.names=NA, sep='\t', quote = FALSE)
