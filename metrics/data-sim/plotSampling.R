##plot simulation results with sampling


allfiles=list.files('.')
corfiles=allfiles[grep('correlation-',allfiles)]

fulltab<-do.call(rbind,lapply(corfiles,function(x) read.table(x,header=T)))

library(ggplot2)

res = ggplot(fulltab,aes(x=sample,y=value,col=cellType))+geom_jitter()+facet_grid(matrix~prot.algorithm)
ggsave('samplingResultsForProt.pdf',res,width=12)


##now do the mrna
res2<-ggplot(fulltab,aes(x=sample,y=value,fill=cellType))+geom_point()+facet_grid(matrix~prot.algorithm)