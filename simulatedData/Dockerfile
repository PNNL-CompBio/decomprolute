FROM rocker/tidyverse


COPY *rda /bin/
COPY getSimDataMatrices.R /bin/

RUN chmod 777 /bin/getSimDataMatrices.R

VOLUME ['/tmp']
