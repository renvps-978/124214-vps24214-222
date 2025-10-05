# ====== BASE ======
FROM ubuntu:22.04

# ====== INSTALL DEPENDENCIES ======
RUN apt-get update && \
    apt-get install -y shellinabox curl wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ====== SET ROOT PASSWORD ======
ARG ROOT_PASS=changeme
RUN echo "root:${ROOT_PASS}" | chpasswd

# ====== INSTALL CLOUDFLARE TUNNEL ======
RUN curl -fsSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o /tmp/cloudflared.deb && \
    dpkg -i /tmp/cloudflared.deb && \
    rm /tmp/cloudflared.deb

# ====== EXPOSE PORT ======
EXPOSE 4200

# ====== STARTUP SCRIPT ======
RUN mkdir -p /root/scripts
COPY start.sh /root/scripts/start.sh
RUN chmod +x /root/scripts/start.sh

# ====== ENTRYPOINT ======
CMD ["/root/scripts/start.sh"]
