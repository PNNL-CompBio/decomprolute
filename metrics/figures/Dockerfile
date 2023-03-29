FROM rocker/r-ver:4
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"
RUN Rscript -e 'install.packages(c("readxl","tidyr","dplyr","tibble","argparser","cowplot","viridis","reshape2","devtools"))'

RUN Rscript -e 'Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")'
RUN Rscript -e 'devtools::install_github("katiejolly/nationalparkcolors")'

COPY combine_results.R /bin
#COPY immune_subtypes.R /bin

#COPY pancan_immune_subtypes.csv /bin

RUN chmod 777 /bin/combine_results.R
#RUN chmod 777 /bin/immune_subtypes.R

#VOLUME ['/tmp']
