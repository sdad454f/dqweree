FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 安装工具
RUN apt-get update && \
    apt-get install -y wget curl ca-certificates gnupg lsb-release jq gzip && \
    wget https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-amd64.deb && \
    dpkg -i couchbase-release-1.0-amd64.deb && \
    apt-get update && \
    apt-get install -y couchbase-server-community couchbase-tools && \
    curl https://rclone.org/install.sh | bash && \
    rm -rf /var/lib/apt/lists/*

# 默认变量（可被 docker run 覆盖）
ENV EXPORT_DIR=/backup/export
ENV EXPORT_FILE=export.json
ENV ARCHIVE_NAME=capella_backup.tar.gz
ENV SCOPE_FIELD=scope_collection

WORKDIR /backup

COPY .github/certs/capella.pem /certs/capella.pem
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
