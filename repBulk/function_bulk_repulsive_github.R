# -- index matrix is a two dimensional matrix. first column contain the 1st component ID, second column the 2nd component ID and
# -- the third column the gene name which is upregulated in component 1 compared to component 2.

gibbs.sampling<-function(n.iter,Y,p,n,K,index.matrix,burn.in,mean.prior,sigma.prior){

  library("MCMCpack")
  library("truncnorm")
#  library(invgamma)

  # Y: pxn matrix of single cell for one patient
  # -- prior
  alpha.sigma<-3
  beta.sigma<-1 # -- prior inverse-gamma for variance parameter
  alpha<-rep(1,K)
  tau<-2; eta<-2

  mean.save<-NULL
  TP<-FP<-NULL

  # -- initial paramter
  mu<-sigma<-NULL
  mean.initial<-matrix(0,p,K)
  rho<-.5
  alpha<-rep(1,K)

  pi<-matrix(0,n,K); V<-matrix(runif(K*n),n,K); V[,K]<-1
  for (j in 1:n) pi[j,]<-c(1,cumprod(1-V[j,-K]))*V[j,]

  mean.initial[,1]<-rnorm(p,mean=mean.prior[,1],sd=sigma.prior); mean.initial[index.matrix[index.matrix[,1]==1,3],1]<-mean.initial[index.matrix[index.matrix[,1]==1,3],1]+1;
  mu[[1]]<-mean.initial[,1];  sigma[[1]]<-rinvgamma(p,1,1);
  for (k in 2:K) { # -- sample mu and sigma from prior

    if (sum((index.matrix[,2]==k & index.matrix[,1]<k) | (index.matrix[,1]==k &index.matrix[,2]< k))>0){
    # -- sample mean for unconstrained genes from normal distribution
    gene.constrain<-unique(index.matrix[(index.matrix[,2]==k & index.matrix[,1]<k) | (index.matrix[,1]==k &index.matrix[,2]< k) ,3])
    mean.initial[-gene.constrain,k]<-rnorm(p-length(gene.constrain),mean=mean.prior[-gene.constrain,k],sd=1)

    # -- sample mean for constrained genes upregulated in k-th component from truncated normal
    if (sum(index.matrix[,1]==k &index.matrix[,2]< k)!=0){
    gene.higher<-unique(index.matrix[index.matrix[,1]==k & index.matrix[,2]< k,3])
    lower.bound<-rep(NA,p)
    for (s in 1:(k-1)) {
       gene.higher.s<-index.matrix[index.matrix[,1]==k & index.matrix[,2]==s,3] # -- select genes supposed to be up in k-th component compared to the s-th component
       lower.bound[gene.higher.s]<-apply(cbind(lower.bound[gene.higher.s],mean.initial[gene.higher.s,s]),1,function(x) max(x[!is.na(x)]))
    }
    lower.bound<-lower.bound[gene.higher]
    bound<-(-tau/log(rho))^(1/eta);
    bound<-bound+lower.bound # lower bound
    mean.initial[gene.higher,k]<-rtruncnorm(1, a=bound, b=Inf, mean =mean.prior[gene.higher,k], sd = sigma.prior)
    }

    if (sum((index.matrix[,2]==k & index.matrix[,1]<k))!=0) {
    gene.lower<-unique(index.matrix[index.matrix[,2]==k & index.matrix[,1]<k,3]) #- - set of genes where k-th component is lower than some others
    upper.bound<-rep(NA,p)
    for (s in 1:(k-1)) { # -- upper bound over component
      gene.lower.s<-index.matrix[index.matrix[,1]==s & index.matrix[,2]==k,3] # -- select genes supposed to be up in k-th component compared to the s-th component
      upper.bound[gene.lower.s]<-apply(cbind(upper.bound[gene.lower.s],mean.initial[gene.lower.s,s]),1,function(x) min(x[!is.na(x)]))
    }
    upper.bound<-upper.bound[gene.lower]

    bound<-(-tau/log(rho))^(1/eta);
    bound<- upper.bound-bound # upper bound
    mean.initial[gene.lower,k]<-rtruncnorm(1, a=-Inf, b=bound, mean =mean.prior[gene.lower,k], sd = sigma.prior)
    }
    } else {
      mean.initial[,k]<-rnorm(p,mean=0,sd=1)
    }
    mu[[k]]<-mean.initial[,k];
    }   # --- K dimensionali list, each element containing mean/sigma parameter of p genes
   sigma<-rinvgamma(p,1,1);

  #######################################################################################################
  ## -- run gibbs sampling
  pi.final<-NULL
  library(Rfast)
  mu.mean<-pi.mean<-list(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
  mean.final<-mean.initial
  for (j in 1:n.iter){ # -- for loop over iterations
    print(j)
    # --- saple pi's from stick breaking (truncated normal)
    # V (matrix K x n); pi (n x k)
    # prod.V<-apply(1-V,2,cumprod)
    V[,K]<-1
    for (j.n in 1:n){
      for (w in 1:(K-1)){
        T_w<-Y[,j.n]
        S_w<-mu[[w]]*pi[j.n,w]/V[j.n,w]
        for (jj in 1:K) {
          if (jj<w) {T_w<-T_w-pi[j.n,jj]*mu[[jj]]}
            if (jj>w) {T_w<-T_w-pi[j.n,jj]*mu[[jj]]/(1-V[j.n,w])}
            if (jj>w) {S_w<-S_w-pi[j.n,jj]*mu[[jj]]/(1-V[j.n,w])}

        }
          S_w<-S_w/sqrt(sigma)
          T_w<-T_w/sqrt(sigma)

          sigma.V<-.1
          var.p<-(sum(S_w^2)+1/sigma.V)^(-1)
          mean.p<-sum(T_w*S_w)*var.p
          
          # -- sample V from truncated normal distribution
         # V[j.n,w]<-qnorm(pnorm((0-mean.p)/sqrt(var.p))+runif(1)*(pnorm((1-mean.p)/sqrt(var.p))-pnorm((0-mean.p)/sqrt(var.p))))*sqrt(var.p)+mean.p  # -- sample from inverse normal
          V[j.n,w]<-rtruncnorm(1,a=0,b=1,mean=mean.p,sd=sqrt(var.p))
          if ( V[j.n,w]=="Inf") V[j.n,w]<-1
          if ( V[j.n,w]=="-Inf") V[j.n,w]<-0
          pi[j.n,]<-c(1,cumprod((1-V[j.n,-K])))*V[j.n,]
         
          if ((sum(V))=="Inf") break
          
        }
    }
    # --- sample mean parameter
    
    for (k in 1:K) {

      total.mu<-0
      for (s in 1:K) { if (s!=k) total.mu<-total.mu+as.matrix(pi[,s]) %*% mu[[s]]}
      
      var.k<-(1/sigma.prior+sum(pi[,k]^2)/sigma)^(-1) # -- p x 1 vector
      mu.k<-rowSums(sweep(as.matrix(Y - t(total.mu)),2,pi[,k],"*"))/sigma 
      mean.p<-(var.k)*(mu.k+mean.prior[,k]/sigma.prior)
      var.p<-(var.k) 
      
      # -- sample mean for unconstrained genes from normal distribution
      if (sum(index.matrix[,2]==k | index.matrix[,1]==k)==0){
        mean.final[,k]<-rnorm(p,mean=0,sd=1)*sqrt((var.p))+mean.p
      }
      if (sum(index.matrix[,2]==k | index.matrix[,1]==k)!=0){
      gene.constrain<-unique(index.matrix[index.matrix[,2]==k | index.matrix[,1]==k ,3])
      mean.final[-gene.constrain,k]<-rnorm(p-length(gene.constrain),mean=0,sd=1)*sqrt((var.p[-gene.constrain]))+mean.p[-gene.constrain]

      # -- sample mean for constrained genes upregulated in k-th component from truncated normal
      gene.higher<-unique(index.matrix[index.matrix[,1]==k,3])
      mean.gene.h<-mean.p[gene.higher]; var.gene.h<-var.p[gene.higher]
      lower.bound<-rep(NA,p)
      for (s in 1:K) {
        if (s!=k & sum(index.matrix[,1]==k & index.matrix[,2]==s)>0) {
          gene.higher.s<-index.matrix[index.matrix[,1]==k & index.matrix[,2]==s,3] # -- select genes supposed to be up in k-th component compared to the s-th component
          lower.bound[gene.higher.s]<-apply(cbind(lower.bound[gene.higher.s],mean.final[gene.higher.s,s]),1,function(x) max(x[!is.na(x)]))
        }
      }
      lower.bound<-lower.bound[gene.higher]
      bound<-(-tau/log(rho))^(1/eta); 
      if (bound<0) bound<-0
      bound<-bound+lower.bound # lower bound
      #mean.final[gene.higher,k]<-qnorm(pnorm((bound-mean.gene.h)/sqrt(var.gene.h))+runif(length(gene.higher))*(1-pnorm((bound-mean.gene.h)/sqrt(var.gene.h))))*sqrt(var.gene.h)+mean.gene.h  # -- sample from inverse normal
      mean.final[gene.higher,k]<-rtruncnorm(1, a=bound, b=Inf, mean = mean.gene.h, sd = sqrt(var.gene.h))
      
      gene.lower<-unique(index.matrix[index.matrix[,2]==k,3]) #- - set of genes where k-th component is lower than some others
      mean.gene.l<-mean.p[gene.lower]; var.gene.l<-var.p[gene.lower]
      upper.bound<-rep(NA,p)
      for (s in 1:K) { # -- upper bound over component
        if (s!=k & sum(index.matrix[,2]==k & index.matrix[,1]==s)>0) {
          gene.lower.s<-unique(index.matrix[index.matrix[,1]==s & index.matrix[,2]==k,3]) # -- select genes supposed to be up in s-th component compared to the k-th component
          upper.bound[gene.lower.s]<-apply(cbind(upper.bound[gene.lower.s],mean.final[gene.lower.s,s]),1,function(x) min(x[!is.na(x)]))
        }
      }
      upper.bound<-upper.bound[gene.lower]
      
      bound<-(-tau/log(rho))^(1/eta); 
      bound<- upper.bound-bound # upper bound
      #mean.final[gene.lower,k]<-qnorm(runif(length(gene.lower))*(pnorm((bound-mean.gene.l)/sqrt(var.gene.l))))*sqrt(var.gene.l)+mean.gene.l  # -- sample from inverse normal
      mean.final[gene.lower,k]<-rtruncnorm(1, a=-Inf, b=bound, mean = mean.gene.l, sd = sqrt(var.gene.l))
      
      if (is.nan(sum(mean.final))) break
      
    }
      mu[[k]]<-mean.final[,k]
    }

  # -- sample sigma from full conditional
   total.mu<-0
   for (k in 1:K) total.mu<-total.mu+as.matrix(pi[,k])%*%mu[[k]]
   total.mu<-t(total.mu)
   
   alpha.p<-(alpha.sigma+n/2); 
   beta.p<-(beta.sigma+0.5*rowSums((Y- total.mu)^2))
  
   sigma.final<-rep(0,p)      
   for (g in 1:p)  sigma.final[g]<- 1/rgamma(1,shape=alpha.p,rate=beta.p[g])      
   sigma<-sigma.final
   if (is.na(sum(sigma))) break
   
# -- sample rho
      n.S<-NULL
      bound<-NULL
      for (k in 1:K)  {
        for (s in 1:K){
        if (s!=k) {
          gene<-unique(index.matrix[index.matrix[,1]==k & index.matrix[,2]==s,3])
       #   print(sum((mean.final[gene,k]-mean.final[gene,s])<0))
          bound<-c(bound,min(exp(-tau*(mean.final[gene,k]-mean.final[gene,s])^(-eta))))
        }
        }
      }  
      
        rho<-runif(1,min=0,max=min(bound))
        if (is.nan(rho)) break


        
#        TP<-c(TP,sum(S==S.true))
#        FP<-c(FP,sum(S!=S.true))
        if (j>burn.in) { 
          
          for(k in 1:K) {pi.mean[[k]]<-cbind(pi.mean[[k]],pi[,k])}
          for(k in 1:K) {mu.mean[[k]]<-cbind(mu.mean[[k]],mu[[k]])}
        }
  }
  return(list(pi.mean,mu.mean))
}









