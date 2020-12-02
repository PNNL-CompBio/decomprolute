from amancevice/pandas

RUN pip install cptac

COPY protDataSetsCLI.py /bin/
RUN chmod 777 /bin/protDataSetsCLI.py
COPY getAllDatasets.py /bin/
RUN python /bin/getAllDatasets.py

VOLUME ['/tmp']
