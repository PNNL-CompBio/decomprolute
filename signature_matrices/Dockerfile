FROM rocker/r-ver:4
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"
RUN Rscript -e 'install.packages(c("readxl","tidyr","dplyr","tibble"))'

COPY *txt /
COPY *xlsx /
COPY getSigMatrices.R /
COPY *xlsx /

RUN chmod 777 /getSigMatrices.R

#VOLUME ['/tmp']
