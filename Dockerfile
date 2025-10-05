FROM node:20-slim

# Cài gói cơ bản (gọn nhất có thể)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl bash tini ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Cập nhật npm và cài code-server
RUN npm install -g npm@latest && \
    npm install -g code-server --unsafe-perm --ignore-scripts --no-audit --prefer-offline

# Thư mục làm việc
WORKDIR /root/project

# Thiết lập biến môi trường
ENV PORT=8080
ENV PASSWORD=123456

# Expose port cho Render
EXPOSE 8080

# Dùng tini để tránh crash process
ENTRYPOINT ["/usr/bin/tini", "--"]

# ✅ Lệnh chính — giữ tiến trình code-server sống liên tục
CMD ["sh", "-c", "code-server /root/project --bind-addr 0.0.0.0:${PORT} --auth password || tail -f /dev/null"]
