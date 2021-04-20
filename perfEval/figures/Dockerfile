FROM rocker/tidyverse


RUN Rscript -e 'install.packages("argparser"); install.packages("cowplot"); install.packages("viridis")'
COPY combine_results.R /bin

RUN chmod 777 /bin/combine_results.R

VOLUME ['/tmp']
