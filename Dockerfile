# Base image: code-server chính thức
FROM codercom/code-server:latest

# Chạy với quyền root
USER root

# Cài thêm công cụ cơ bản
RUN apt-get update && apt-get install -y \
    git curl wget vim sudo htop net-tools unzip zip && \
    rm -rf /var/lib/apt/lists/*

# Cho phép sudo không cần password
RUN echo "root ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Thiết lập môi trường làm việc
WORKDIR /root/project
RUN mkdir -p /root/project

# Render sẽ inject PORT
ENV PORT=8080
ENV PASSWORD=changeme

EXPOSE 8080

# Dùng bash trực tiếp để tránh lỗi "-c"
CMD bash -lc "code-server /root/project --bind-addr 0.0.0.0:${PORT} --auth password --password ${PASSWORD}"
