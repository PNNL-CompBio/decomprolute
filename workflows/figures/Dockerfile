FROM rocker/tidyverse

RUN Rscript -e 'Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")' && Rscript -e 'install.packages("argparser"); install.packages("cowplot"); install.packages("grid"); install.packages("viridis"); install.packages("reshape2"); install.packages("devtools"); devtools::install_github("katiejolly/nationalparkcolors")'

COPY combine_results.R /bin
COPY immune_subtypes.R /bin
COPY immune_subtypes_heatmap.R /bin
COPY immune_subtypes_histgram.R /bin

COPY pancan_immune_subtypes.csv /bin

RUN chmod 777 /bin/combine_results.R
RUN chmod 777 /bin/immune_subtypes.R
RUN chmod 777 /bin/immune_subtypes_heatmap.R
RUN chmod 777 /bin/immune_subtypes_histgram.R

#VOLUME ['/tmp']
