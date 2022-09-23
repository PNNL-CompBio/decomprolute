from amancevice/pandas
RUN pip install --upgrade cptac
COPY mRNADataSetsCLI.py /bin/
RUN chmod 777 /bin/mRNADataSetsCLI.py
COPY getAllDatasets.py /bin/
RUN python /bin/getAllDatasets.py
#VOLUME ['/tmp']
WORKDIR ['/tmp']
