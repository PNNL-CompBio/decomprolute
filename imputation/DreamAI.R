require("cluster")
require("survival")
require("randomForest")
require("missForest")
require("glmnet")
require("Rcpp")
require("foreach")
require("itertools")
require("iterators")
require("Matrix")
require("impute")
require("DreamAI")

args <- commandArgs(trailingOnly = TRUE)
argsLen <- length(args)
input_f <- args[1]
use_MissForest <- if (argsLen < 2) TRUE else args[2];

data = read.csv(input_f, header=TRUE, row.names=1, sep = '\t')
# remove rows where all data is NA
data = data[rowSums(is.na(data)) != ncol(data), ]

if (use_MissForest) {
    impute<- DreamAI(data,k=10,maxiter_MF = 10, ntree = 100,maxnodes = NULL,maxiter_ADMIN=30,tol=10^(-2),gamma_ADMIN=0,gamma=50,CV=FALSE,fillmethod="row_mean",maxiter_RegImpute=10,conv_nrmse = 1e-6,iter_SpectroFM=40, method = c("KNN", "ADMIN", "MissForest", "Brinn", "SpectroFM", "RegImpute"),out="Ensemble")
} else {
    impute<- DreamAI(data,k=10,maxiter_MF = 10, ntree = 100,maxnodes = NULL,maxiter_ADMIN=30,tol=10^(-2),gamma_ADMIN=0,gamma=50,CV=FALSE,fillmethod="row_mean",maxiter_RegImpute=10,conv_nrmse = 1e-6,iter_SpectroFM=40, method = c("KNN", "ADMIN", "Brinn", "SpectroFM", "RegImpute"),out="Ensemble")
}

write.table(impute$Ensemble,"imputed_file.tsv",row.names=TRUE, col.names=NA, sep='\t', quote = FALSE)
