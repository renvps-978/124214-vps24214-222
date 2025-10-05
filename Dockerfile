# === Base image: Ubuntu 22.04 ===
FROM ubuntu:22.04

# === Cài Python 3.12, pip, curl, tini và các tiện ích cơ bản ===
RUN apt-get update && \
    apt-get install -y software-properties-common curl tini && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y python3.12 python3.12-venv python3.12-distutils python3-pip && \
    pip install --no-cache-dir jupyterlab && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# === Tạo thư mục làm việc ===
WORKDIR /workspace

# === Copy entrypoint script ===
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# === Mở port 8888 cho JupyterLab ===
EXPOSE 8888

# === Dùng tini để xử lý tín hiệu sạch sẽ ===
ENTRYPOINT ["/usr/bin/tini", "--"]

# === Khi container khởi động thì chạy script ===
CMD ["/entrypoint.sh"]
