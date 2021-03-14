from amancevice/pandas:1.2.0

RUN pip install cptac
COPY mRNADataSetsCLI.py /bin/
RUN chmod 777 /bin/mRNADataSetsCLI.py
COPY getAllDatasets.py /bin/
RUN python /bin/getAllDatasets.py

VOLUME ['/tmp']
