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
require("devtools")
require("impute")

require("remotes")
install_github("WangLab-MSSM/DreamAI/Code")

require("DreamAI")

data(datapnnl)
data<-datapnnl.rm.ref[1:100,1:21]
impute<- DreamAI(data,k=10,maxiter_MF = 10, ntree = 100,maxnodes = NULL,maxiter_ADMIN=30,tol=10^(-2),gamma_ADMIN=NA,gamma=50,CV=FALSE,fillmethod="row_mean",maxiter_RegImpute=10,conv_nrmse = 1e-6,iter_SpectroFM=40, method = c("KNN", "MissForest", "ADMIN", "Birnn", "SpectroFM", "RegImpute"),out="Ensemble")
impute$Ensemble
