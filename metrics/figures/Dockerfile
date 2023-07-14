FROM rocker/r-ver:4
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >>"${R_HOME}/etc/Rprofile.site"

#RUN Rscript -e 'Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")'
RUN Rscript -e 'install.packages("devtools",dependences=TRUE); devtools::install_github("katiejolly/nationalparkcolors")'
RUN Rscript -e 'install.packages("readxl",dependencies=TRUE)'
RUN Rscript -e 'install.packages("tidyr",dependencies=TRUE)'
RUN Rscript -e 'install.packages("dplyr",dependencies=TRUE)'
RUN Rscript -e 'install.packages("argparser",dependencies=TRUE)'
RUN Rscript -e 'install.packages("cowplot",dependencies=TRUE)'
RUN Rscript -e 'install.packages("viridis",dependencies=TRUE)'
RUN Rscript -e 'install.packages("reshape2",dependencies=TRUE)'



COPY combine_results.R /bin
#COPY immune_subtypes.R /bin

#COPY pancan_immune_subtypes.csv /bin

RUN chmod 777 /bin/combine_results.R
#RUN chmod 777 /bin/immune_subtypes.R

VOLUME ['/tmp']
