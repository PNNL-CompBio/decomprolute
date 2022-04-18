FROM rocker/tidyverse


COPY *txt /
COPY *xlsx /
COPY getSigMatrices.R /

RUN chmod 777 /getSigMatrices.R

#VOLUME ['/tmp']
