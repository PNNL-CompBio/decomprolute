FROM rocker/r-base

RUN apt-get update && apt-get install -y gcc g++ perl python automake make wget git curl libdb-dev zlib1g-dev bzip2 libncurses5-dev gfortran build-essential libghc-zlib-dev libncurses-dev libbz2-dev liblzma-dev libpcre3-dev libxml2-dev libblas-dev gfortran git unzip ftp libzmq3-dev nano ftp fort77 libreadline-dev libcurl4-openssl-dev libx11-dev libxt-dev x11-common libcairo2-dev libpng-dev libreadline6-dev libjpeg-dev pkg-config libtbb-dev default-jdk libssl-dev libssh2-1-dev && apt-get clean

# texlive-full
RUN mkdir data
RUN wget -O data/lm7c_ref.txt --no-check-certificate https://ndownloader.figshare.com/files/26488094
RUN wget -O data/lm9_ref.txt --no-check-certificate https://ndownloader.figshare.com/files/26488223
RUN wget -O data/lm22_ref.txt --no-check-certificate https://ndownloader.figshare.com/files/26488313
RUN wget -O data/pbmc_ref.txt --no-check-certificate https://ndownloader.figshare.com/files/26504420


ENV SRC /usr/local/src
ENV BIN /usr/local/bin

WORKDIR $SRC

RUN Rscript -e 'Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")' && \
    Rscript -e 'install.packages("devtools")' && \
    Rscript -e 'install.packages("remotes")' && \
    Rscript -e 'require("devtools");require("remotes");install_github("GfellerLab/EPIC", build_vignettes=TRUE)'

COPY epic.r /bin

ENV HOME /bin
WORKDIR /bin

VOLUME ['/tmp']
