FROM ubuntu:16.04

RUN apt-get update && apt-get install -y gcc g++ perl python automake make wget git curl libdb-dev zlib1g-dev bzip2 libncurses5-dev texlive-full gfortran build-essential libghc-zlib-dev libncurses-dev libbz2-dev liblzma-dev libpcre3-dev libxml2-dev libblas-dev gfortran git unzip ftp libzmq3-dev nano ftp fort77 libreadline-dev libcurl4-openssl-dev libx11-dev libxt-dev x11-common libcairo2-dev libpng12-dev libreadline6-dev libjpeg8-dev pkg-config libtbb-dev default-jdk && apt-get clean

ENV SRC /usr/local/src
ENV BIN /usr/local/bin

WORKDIR $SRC

ENV R_VERSION=R-4.0.3

RUN curl https://cran.r-project.org/src/base/R-4/$R_VERSION.tar.gz -o $R_VERSION.tar.gz && tar xvf $R_VERSION.tar.gz && cd $R_VERSION && ./configure --with-x=no --with-readline=no --with-pcre1 && make && make install

RUN apt-get install -y libssl-dev libssh2-1-dev && \
    Rscript -e 'Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")' && \
    Rscript -e 'install.packages(c("devtools","curl"),repos = "http://cran.us.r-project.org")' && \
    Rscript -e 'library(devtools);install_github("ebecht/MCPcounter",ref="master", subdir="Source")'

COPY mcpcounter.r /root

ENV HOME /root
WORKDIR /root

VOLUME ['/tmp']