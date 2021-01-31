#
# speedup builds by pre-building all the heavy stuff, e.g. numpy
#
# docker build -t asah/mplfinance -f Dockerfile.mplfinance .; docker push asah/mplfinance
#
# run DNY inside docker, for reproducibility and ease of installation
#
FROM python:3.9.1-buster
RUN pip3 install Cython
RUN git clone https://github.com/numpy/numpy.git
RUN cd numpy; pip3 install . --no-binary :all: --no-use-pep517
RUN pip3 install pandas pandasql
RUN pip3 install matplotlib mplfinance
RUN pip3 install requests python-dateutil bs4 lxml pyyaml
RUN pip3 install filelock

CMD [ "/bin/bash" ]
