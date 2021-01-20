FROM python:3.7.9
RUN pip install pandas

COPY correlation.py /bin
COPY correlationXcelltypes.py /bin

RUN chmod 777 /bin/correlation.py
RUN chmod 777 /bin/correlationXcelltypes.py

VOLUME ['/tmp']