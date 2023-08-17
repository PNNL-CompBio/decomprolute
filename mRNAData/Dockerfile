from amancevice/pandas:1.4.0-slim
#RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
#RUN apt update gcc fortran python-dev build-base wget freetype-dev libpng-dev openblas-dev py-numpy
#RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip install --no-cache-dir numpy scipy matplotlib

RUN pip install --upgrade cptac
COPY mRNADataSetsCLI.py /bin/
RUN chmod 777 /bin/mRNADataSetsCLI.py
COPY getAllDatasets.py /bin/
#RUN python /bin/getAllDatasets.py
#VOLUME ['/tmp']
WORKDIR ['/tmp']
