FROM node:20-slim

# Cài công cụ cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl bash tini ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Cập nhật npm và cài code-server đúng cách
RUN npm install -g npm@latest && \
    npm install -g code-server --unsafe-perm --no-audit --prefer-offline

# Tạo thư mục làm việc
WORKDIR /root/project

# Thiết lập biến môi trường
ENV PORT=8080
ENV PASSWORD=123456
ENV HOME=/root

# Mở cổng cho Render
EXPOSE 8080

# Dùng tini làm init process
ENTRYPOINT ["/usr/bin/tini", "--"]

# Lệnh chính — đảm bảo code-server chạy và giữ tiến trình
CMD ["sh", "-c", "code-server /root/project --bind-addr 0.0.0.0:${PORT} --auth password"]
