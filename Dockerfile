FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget curl ca-certificates jq gzip tar && \
    rm -rf /var/lib/apt/lists/*

# 下载官方 dev-tools（包含 cbexport）
# 使用 -O 统一命名，并去掉 -z 让 tar 自动识别格式
RUN wget -O couchbase.tar https://file.upfile.live/uploads/20260416/0df004b7a47265da3c05a5b345a98ff6.tar && \
    tar -xf couchbase.tar && \
    # 假设解压出的目录以 couchbase-server 开头
    mv couchbase-server-* /opt/couchbase-tools && \
    ln -s /opt/couchbase-tools/bin/* /usr/local/bin/ && \
    rm couchbase.tar

WORKDIR /backup

COPY .github/certs/capella.pem /certs/capella.pem
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
