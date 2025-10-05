# Base image: code-server chính thức
FROM codercom/code-server:latest

# Chạy với quyền root để có toàn quyền hệ thống
USER root

# Cài thêm công cụ cơ bản
RUN apt-get update && apt-get install -y \
    git curl wget vim sudo htop net-tools unzip zip && \
    rm -rf /var/lib/apt/lists/*

# Cho phép sudo không cần password (đề phòng cần dùng)
RUN echo "root ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Thiết lập môi trường làm việc
WORKDIR /root/project
RUN mkdir -p /root/project

# Render sẽ gán PORT tự động
ENV PORT=8080

# Biến môi trường chứa password (bạn sẽ set trong Render)
ENV PASSWORD=changeme

# Mở cổng
EXPOSE 8080

# Chạy VSCode web (có password)
CMD ["sh", "-c", "code-server /root/project --bind-addr 0.0.0.0:${PORT} --auth password --password ${PASSWORD}"]
