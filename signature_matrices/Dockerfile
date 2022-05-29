FROM rocker/tidyverse


COPY *txt /
COPY *xlsx /
COPY getSigMatrices.R /
COPY *xlsx /

RUN chmod 777 /getSigMatrices.R

#VOLUME ['/tmp']
