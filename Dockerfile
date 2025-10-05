# Sử dụng Ubuntu 22.04 làm base image
FROM ubuntu:22.04

# Cài Shellinabox + curl
RUN apt-get update && \
    apt-get install -y shellinabox curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy script vào container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose duy nhất 1 port (Render sẽ nhận đây là web service port)
EXPOSE 4200

# Chạy script khởi động
CMD ["/entrypoint.sh"]
