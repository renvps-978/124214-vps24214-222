#!/bin/bash
echo "🔹 Starting Shellinabox..."
/usr/bin/shellinaboxd -t --disable-ssl -s /:LOGIN &

sleep 3

echo "🔹 Starting Cloudflare Tunnel..."
# Chạy trực tiếp để log hiện ra stdout
cloudflared tunnel --url http://localhost:4200 --no-autoupdate --metrics localhost:0 2>&1 | tee /root/tunnel.log | awk '/trycloudflare.com/ {print "🌍 Tunnel URL: "$NF; fflush()}'

# Giữ container sống mãi
tail -f /dev/null
