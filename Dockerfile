FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y ca-certificates jq gzip tar && \
    rm -rf /var/lib/apt/lists/*

# 直接使用你上传的 dev-tools 包（不再下载）
COPY tools/couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz /tmp/devtools.tar.gz

RUN tar -xzf /tmp/devtools.tar.gz -C /opt && \
    mv /opt/couchbase-server-dev-tools-8.0.1-linux_x86_64 /opt/couchbase-tools && \
    ln -s /opt/couchbase-tools/bin/* /usr/local/bin/ && \
    rm /tmp/devtools.tar.gz

WORKDIR /backup

COPY .github/certs/capella.pem /certs/capella.pem
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
