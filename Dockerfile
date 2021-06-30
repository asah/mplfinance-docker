#
# speedup builds by pre-building all the heavy stuff, e.g. numpy
#
# sudo docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag asah/mplfinance:buildx-latest .
#
# run DNY inside docker, for reproducibility and ease of installation
#
FROM python:3.9.6-buster

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

ADD . .

RUN python3.9 -m pip install -r requirements.txt

CMD [ "/bin/bash" ]
