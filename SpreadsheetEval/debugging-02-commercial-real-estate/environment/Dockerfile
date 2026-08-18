FROM python:3.11.10-bullseye
RUN sed -i -e 's|http://deb.debian.org|https://mirrors.aliyun.com|g' -e 's|http://security.debian.org|https://mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list \
 && apt-get -o Acquire::Retries=10 update \
 && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=10 install -y --no-install-recommends libreoffice-calc python3-uno \
 && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir openpyxl==3.1.5
WORKDIR /workspace
COPY input.xlsx /workspace/input.xlsx
CMD ["sleep", "infinity"]
