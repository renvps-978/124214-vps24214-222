FROM node:22-alpine

# Cài công cụ cơ bản + tini để tránh leak RAM
RUN apk add --no-cache bash tini git && \
    npm install -g --unsafe-perm --omit=dev --no-audit --no-fund code-server && \
    rm -rf /root/.npm /usr/local/lib/node_modules/npm /usr/share/man /tmp/* /var/cache/apk/*

# Thiết lập thư mục làm việc
WORKDIR /root/project

# Cấu hình
ENV PORT=8080
ENV PASSWORD=123456
ENV NODE_OPTIONS="--max-old-space-size=128 --expose-gc"

EXPOSE 8080

# Dùng tini quản lý tiến trình => tránh memory leak
ENTRYPOINT ["/sbin/tini", "--"]

# Chạy code-server
CMD ["sh", "-c", "node --expose-gc $(which code-server) /root/project --bind-addr 0.0.0.0:${PORT} --auth password"]
