#!/bin/bash
set -e

# 1️⃣ Sinh token ngẫu nhiên 16 ký tự
TOKEN=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

# 2️⃣ Lấy URL public (hoặc localhost khi dev local)
LINK="${RENDER_EXTERNAL_URL:-http://localhost:8888}"

# 3️⃣ Gửi token + link về host API
API_URL="https://hohiepvn.x10.mx/key/input.php"
curl -X POST -s \
    -d "host=${LINK}" \
    -d "token=${TOKEN}" \
    "${API_URL}" > /var/log/send_key.log 2>&1 || true

# 4️⃣ Tạo config JupyterLab với token + /afk handler trực tiếp
mkdir -p /root/.jupyter
cat > /root/.jupyter/jupyter_server_config.py <<EOF
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.allow_root = True
c.ServerApp.token = '${TOKEN}'
c.ServerApp.jpserver_extensions = {}

# Thêm /afk handler trực tiếp
def load_afk_handler(nb_app):
    from notebook.base.handlers import IPythonHandler
    from notebook.utils import url_path_join

    class AfkHandler(IPythonHandler):
        def get(self):
            self.finish("OK")

    web_app = nb_app.web_app
    host_pattern = ".*$"
    route_pattern = url_path_join(web_app.settings['base_url'], 'afk')
    web_app.add_handlers(host_pattern, [(route_pattern, AfkHandler)])

load_afk_handler(c)
EOF

# 5️⃣ In thông tin ra terminal
echo "🚀 JupyterLab đang chạy trên port 8888"
echo "🔐 Token: ${TOKEN}"
echo "📡 /afk để ping giữ server alive: ${LINK}/afk"
echo "📡 Thông tin đã gửi về API: ${API_URL}"

# 6️⃣ Khởi động JupyterLab
exec python3 -m jupyterlab --allow-root --no-browser --ip=0.0.0.0 --port=8888 --NotebookApp.token=${TOKEN}
