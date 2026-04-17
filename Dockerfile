# 使用更轻量、速度更快的 Debian Slim
FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# 安装基础依赖
# Debian Slim 必须安装 ca-certificates 才能通过 https 下载文件
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    jq \
    gzip \
    tar && \
    rm -rf /var/lib/apt/lists/*

# 下载并安装 Couchbase Dev Tools
# 逻辑：创建目录 -> 下载 -> 直接解压到目录并剥离一层文件夹 -> 软链接
RUN mkdir -p /opt/couchbase-tools && \
    wget -O couchbase.tar https://file.upfile.live/uploads/20260416/0df004b7a47265da3c05a5b345a98ff6.tar && \
    tar -xf couchbase.tar -C /opt/couchbase-tools --strip-components=1 && \
    ln -sf /opt/couchbase-tools/bin/* /usr/local/bin/ && \
    rm couchbase.tar

WORKDIR /backup

# 复制证书和启动脚本
# 注意：确保你的项目中这两个路径确实存在
COPY .github/certs/capella.pem /certs/capella.pem
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
