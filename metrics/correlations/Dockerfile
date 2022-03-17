FROM python:3.7.9
RUN pip install pandas
RUN pip install scipy

COPY correlation.py /bin
COPY correlationXcelltypes.py /bin
COPY getBestCor.py /bin

RUN chmod 777 /bin/correlation.py
RUN chmod 777 /bin/correlationXcelltypes.py
RUN chmod 777 /bin/getBestCor.py

#VOLUME ['/tmp']
