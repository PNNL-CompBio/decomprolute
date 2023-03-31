FROM rocker/r-ver:4.0

RUN Rscript -e 'Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")' && \
	Rscript -e 'install.packages(c("argparser","cowplot","ggridges","viridis","reshape2","remotes","tibble","dplyr","tidyr")); remotes::install_github("katiejolly/nationalparkcolors")'
#COPY combine_results.R /bin
COPY immune_subtypes.R /bin

COPY pancan_immune_subtypes.csv /bin

#RUN chmod 777 /bin/combine_results.R
RUN chmod 777 /bin/immune_subtypes.R

VOLUME ['/tmp']
