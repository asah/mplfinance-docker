FROM python:3.9.1-buster

# pandas is super slow!!!

RUN pip3 install Cython
RUN git clone https://github.com/numpy/numpy.git
RUN cd numpy; pip3 install . --no-binary :all: --no-use-pep517
RUN pip3 install pandas
RUN pip3 install matplotlib
RUN pip3 install mplfinance

WORKDIR /usr/src/app

ADD . .
