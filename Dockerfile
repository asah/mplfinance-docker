#
# speedup builds by pre-building all the heavy stuff, e.g. numpy
#
# sudo docker build -t asah/mplfinance .; sudo docker push asah/mplfinance
# sudo docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag asah/mplfinance:buildx-latest .
#
# run DNY inside docker, for reproducibility and ease of installation
#
FROM python:3.9.1-buster
RUN pip3 install numpy pandas pandasql install matplotlib mplfinance
RUN pip3 install requests python-dateutil bs4 lxml pyyaml filelock

# compile ta-lib from source
# .NOTPARALLEL disables parallel builds - see https://trac.macports.org/changeset/115788
RUN wget -q http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xvzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib/ && \
    wget 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' -O config.guess && \
    chmod 755 config.guess;./configure --prefix=/usr/local  && \
    echo ".NOTPARALLEL:" >> src/tools/gen_code/Makefile && \
    make -j$(python3 -c "import os; print(max(1,os.cpu_count()-2))")  && \
    make install && \
    cd ..; rm -R ta-lib ta-lib-0.4.0-src.tar.gz

RUN pip3 install ta-lib

CMD [ "/bin/bash" ]


# glibtoolize on mac
