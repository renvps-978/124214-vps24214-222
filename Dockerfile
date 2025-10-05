# Stage 1: Build OpenVSCode Server
FROM node:20-slim AS builder

# Cài các dependency cần thiết để build
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates python3 g++ make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone mã nguồn (shallow clone cho nhẹ)
RUN git clone --depth=1 https://github.com/gitpod-io/openvscode-server.git .

# Cài dependencies và build
RUN yarn --frozen-lockfile && yarn build

# Stage 2: Chạy OpenVSCode Server
FROM debian:bookworm-slim

# Cài node + tini (dùng để quản lý tiến trình)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl tini \
    && rm -rf /var/lib/apt/lists/*

# Tạo user non-root để an toàn
RUN useradd -m vscode
USER vscode
WORKDIR /home/vscode

# Copy build từ stage trước
COPY --from=builder /app/out /home/vscode/openvscode-server

# Mở port mặc định
EXPOSE 3000

# Lệnh chạy server
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "openvscode-server/out/vscode-server-main.js", "--host", "0.0.0.0", "--port", "3000"]
