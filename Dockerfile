# 使用轻量级基础镜像
FROM debian:bookworm-slim

# 设置工作目录
WORKDIR /opt/couchbase-tools

# 安装必要依赖
RUN apt-get update && apt-get install -y \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压 Couchbase Dev Tools
# 这里使用您提供的 8.0.1 版本
RUN wget https://packages.couchbase.com/releases/8.0.1/couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz \
    && tar -xf couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz \
    && rm couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz

# 将 bin 目录添加到 PATH
ENV PATH="/opt/couchbase-tools/bin:${PATH}"

# 验证安装
RUN cbexport --version

# 默认执行命令（可选）
CMD ["cbexport"]
