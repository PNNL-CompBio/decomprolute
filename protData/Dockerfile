from amancevice/pandas:1.4.0-alpine
RUN echo "http://dl-8.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk --no-cache --update-cache add gcc gfortran python python-dev py-pip build-base wget freetype-dev libpng-dev openblas-dev
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip install numpy scipy pandas matplotlib

RUN pip install --upgrade cptac
COPY protDataSetsCLI.py /bin/
RUN chmod 777 /bin/protDataSetsCLI.py
COPY getAllDatasets.py /bin/
RUN python /bin/getAllDatasets.py
#VOLUME ['/tmp']
WORKDIR ['/tmp']
