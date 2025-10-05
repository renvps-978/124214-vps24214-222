FROM ubuntu:22.04

# Cài Python + pip + JupyterLab + curl
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl && \
    pip install --no-cache-dir jupyterlab && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8888
USER root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
