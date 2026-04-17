FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget curl ca-certificates gnupg lsb-release jq gzip && \
    wget https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-amd64.deb && \
    dpkg -i couchbase-release-1.0-amd64.deb && \
    apt-get update && \
    apt-get install -y couchbase-tools && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /backup

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
