from amancevice/pandas

RUN apt-get update -qq
RUN pip install requests
RUN pip install seaborn
RUN pip install matplotlib

COPY . protData
WORKDIR protData

VOLUME ['/tmp']
CMD ["python","queryPDCfiles.py"]
