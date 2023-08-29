FROM rocker/r-ver:4

RUN apt-get update
RUN apt-get install -y pkg-config

RUN Rscript -e "install.packages('tibble',dependences=TRUE,repos='http://cran.rstudio.com')"
RUN Rscript -e "install.packages('dplyr',dependences=TRUE,repos='http://cran.rstudio.com')"
RUN Rscript -e "install.packages('readxl',dependences=TRUE,repos='http://cran.rstudio.com')"
RUN Rscript -e "install.packages('tidyr',dependences=FALSE,repos='http://cran.rstudio.com')"

COPY *txt /
COPY *xlsx /
COPY getSigMatrices.R /

RUN chmod 777 /getSigMatrices.R

VOLUME ['/tmp']
