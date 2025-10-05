FROM node:18-slim

RUN apt-get update && apt-get install -y git python3 make g++ && \
    npm install -g @theia/cli && \
    theia build && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
EXPOSE 8080

CMD ["npx", "theia", "start", "/workspace", "--hostname=0.0.0.0", "--port=8080"]
