FROM rocker/tidyverse
RUN Rscript -e 'install.packages("argparser")'

COPY *rda /bin/
COPY getSimDataMatrices.R /bin/

RUN chmod 777 /bin/getSimDataMatrices.R

VOLUME ['/tmp']
