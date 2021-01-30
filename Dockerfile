FROM python:slim

MAINTAINER Hollow Man <hollowman@hollowman.ml>

LABEL version="1.0.8"
LABEL repository="https://github.com/HollowMan6/LZU-Auto-COVID-Health-Report"
LABEL homepage="https://hollowman.ml/"
LABEL maintainer="Hollow Man <hollowman@hollowman.ml>"

COPY entrypoint.sh /entrypoint.sh
COPY LZU-Auto-COVID-Health-Report.py /LZU-Auto-COVID-Health-Report.py
COPY Notify-Using-SeverChan-Or-PushPlus.py /Notify-Using-SeverChan-Or-PushPlus.py
COPY requirements.txt /requirements.txt

ENV TZ Asia/Shanghai

RUN pip install --no-cache-dir --upgrade pip

RUN nocompile=("x86_64" "i386" "aarch64"); if [[ "${nocompile[@]}"  =~ "`arch`" ]]; then \
    pip install --no-cache-dir -r /requirements.txt; else \
    apt-get update \
    && apt-get install -y \
      libxml2 \
      libxslt1-dev \
      gcc \
      zlib1g-dev \
    && pip install --no-cache-dir -r /requirements.txt \
    && chmod +x /entrypoint.sh \
    && apt-get --purge remove -y \
      libxml2 \
      libxslt1-dev \
      gcc \
      zlib1g-dev \
      manpages \
    && apt-get autoremove -y \
    && apt-get install -y \
       libxslt1.1 \
    && apt-get clean; fi

ENTRYPOINT ["/entrypoint.sh"]
