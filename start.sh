#!/bin/bash
echo "🔹 Starting Shellinabox..."
/usr/bin/shellinaboxd -t --disable-ssl -s /:LOGIN &

sleep 3

echo "🔹 Starting Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:4200 --no-autoupdate > /root/tunnel.log 2>&1 &

sleep 5

echo "🔹 Tunnel is running!"
echo "========================================"
grep -m 1 "trycloudflare.com" /root/tunnel.log
echo "========================================"

# Giữ container chạy mãi
tail -f /dev/null
