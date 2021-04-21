FROM rocker/tidyverse


COPY *rda /bin/
COPY getSimDataMatrices.R /bin/
COPY mapSimDataMatrices.R /bin/

RUN chmod 777 /bin/getSimDataMatrices.R
RUN chmod 777 /bin/mapSimDataMatrices.R

VOLUME ['/tmp']
