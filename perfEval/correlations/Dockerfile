FROM python:3.7.9
RUN pip install pandas

COPY correlation.py /bin

RUN chmod 777 /bin/correlation.py

VOLUME ['/tmp']