FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget curl ca-certificates jq gzip tar && \
    rm -rf /var/lib/apt/lists/*

# 下载官方 dev-tools（包含 cbexport）
RUN wget https://packages.couchbase.com/releases/8.0.1/couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz && \
    tar -xzf couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz && \
    mv couchbase-server-dev-tools-8.0.1-linux_x86_64 /opt/couchbase-tools && \
    ln -s /opt/couchbase-tools/bin/* /usr/local/bin/ && \
    rm couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz

WORKDIR /backup

COPY .github/certs/capella.pem /certs/capella.pem
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
