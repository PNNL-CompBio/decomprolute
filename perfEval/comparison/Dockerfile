FROM python:3.7.9
RUN pip install pandas
RUN pip install scipy
RUN pip install numpy

COPY comparison.py /bin

RUN chmod 777 /bin/comparison.py

VOLUME ['/tmp']
