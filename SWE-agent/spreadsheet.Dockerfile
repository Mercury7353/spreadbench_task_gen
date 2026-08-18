# docker build -f spreadsheet.Dockerfile -t spreadsheetbench-v2 .
FROM python:3.11.10-bullseye  

ARG DEBIAN_FRONTEND=noninteractive  
ENV TZ=Etc/UTC

WORKDIR /

# Install swe-rex for faster startup
RUN pip install pipx
RUN pipx install swe-rex
RUN pipx ensurepath
ENV PATH="$PATH:/root/.local/bin/"

# Install any extra dependencies
RUN pip install flake8
RUN pip install openpyxl numpy pandas matplotlib xlsxwriter
RUN sed -i \
    -e 's|http://deb.debian.org|https://mirrors.aliyun.com|g' \
    -e 's|http://security.debian.org|https://mirrors.aliyun.com/debian-security|g' \
    /etc/apt/sources.list
RUN apt-get -o Acquire::Retries=10 -o Acquire::http::Timeout=120 update
RUN apt-get -o Acquire::Retries=10 -o Acquire::http::Timeout=120 install -y libreoffice libreoffice-script-provider-python

# Add LibreOffice UNO library to Python path
ENV PYTHONPATH="/usr/lib/libreoffice/program:/usr/lib/python3/dist-packages:${PYTHONPATH}"

SHELL ["/bin/bash", "-c"]
