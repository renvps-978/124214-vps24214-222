FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl nodejs npm && \
    npm install -g code-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PASSWORD=123456
ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "code-server --bind-addr 0.0.0.0:${PORT} --auth password"]
