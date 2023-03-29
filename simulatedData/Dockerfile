FROM rocker/r-ver:4
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"
RUN Rscript -e 'install.packages(c("readxl","tidyr","dplyr",tibble"))'

COPY *rda /bin/
COPY getSimDataMatrices.R /bin/
COPY mapSimDataMatrices.R /bin/


RUN chmod 777 /bin/getSimDataMatrices.R
RUN chmod 777 /bin/mapSimDataMatrices.R


#VOLUME ['/tmp']
