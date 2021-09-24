FROM r-base:4.0.3

# install DreamAI requirements
RUN R -e "install.packages('cluster',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('survival',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('randomForest',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('missForest',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('glmnet',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Rcpp',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('foreach',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('itertools',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('iterators',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Matrix',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BiocManager',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install('impute')"
RUN R -e "install.packages('remotes',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e 'require("devtools"); require("remotes"); install_github("WangLab-MSSM/DreamAI/Code")'

# copy DreamAI script
COPY DreamAI.R /bin/DreamAI.R
RUN chmod 777 /bin/DreamAI.R

#VOLUME ['/tmp']
