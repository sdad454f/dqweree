FROM debian:bookworm-slim

WORKDIR /opt/couchbase-tools

# 1. 安装基础依赖
RUN apt-get update && apt-get install -y \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 2. 下载并解压
# 注意：解压后通常会生成一个名为 couchbase-server-dev-tools-8.0.1 的文件夹
RUN wget https://packages.couchbase.com/releases/8.0.1/couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz \
    && tar -xf couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz \
    && rm couchbase-server-dev-tools-8.0.1-linux_x86_64.tar.gz

# 3. 核心修正：手动寻找 bin 目录并建立软链接到系统路径
# 这样无论它解压到哪个子目录，/usr/local/bin 都能直接访问到
RUN BIN_PATH=$(find /opt/couchbase-tools -name "bin" -type d) && \
    echo "Found bin at: $BIN_PATH" && \
    chmod +x $BIN_PATH/* && \
    ln -s $BIN_PATH/* /usr/local/bin/

# 4. 验证安装（此时 /usr/local/bin 已经在默认 PATH 中）
RUN cbexport --version
RUN cbimport --version

# 保持 PATH 环境变量以防万一
ENV PATH="/usr/local/bin:${PATH}"

CMD ["cbexport"]
