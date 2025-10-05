# Sử dụng Ubuntu 22.04 làm base image
FROM ubuntu:22.04

# Cài Python + pip + JupyterLab
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl && \
    pip install --no-cache-dir jupyterlab && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose port JupyterLab
EXPOSE 8888

# Sinh token và chạy JupyterLab
CMD TOKEN=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16) && \
    echo "🔐 Token: $TOKEN" && \
    echo "🌐 Mở tại: http://localhost:8888/?token=$TOKEN" && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=$TOKEN
