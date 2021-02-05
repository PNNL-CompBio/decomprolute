FROM r-base:4.0.3
#FROM rocker/tidyverse:3.6.3

# install requirements
RUN R -e "install.packages('MCMCpack',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('truncnorm',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN apt-get update && apt-get install -y git build-essential libgtkmm-3.0-dev libboost-all-dev libgsl-dev libz-dev libbz2-dev libgsl-dev libcurl4-gnutls-dev cmake
RUN R -e "install.packages('Rfast',dependencies=TRUE, repos='http://cran.rstudio.com/')"

# copy script
COPY function_bulk_repulsive_github.R /bin/function_bulk_repulsive_github.R
RUN chmod 777 /bin/function_bulk_repulsive_github.R
COPY Synthetic_example.rda /bin/Synthetic_example.rda
COPY github_code.R /bin/github_code.R
RUN chmod 777 /bin/github_code.R

COPY toy_data.tsv /bin/toy_data.tsv
COPY toy_list_gene.tsv /bin/toy_list_gene.tsv

VOLUME ['/tmp']
