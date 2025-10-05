FROM node:20-bullseye

# Cài đặt dependencies
RUN apt-get update && apt-get install -y git python3 make g++

# Sao chép mã nguồn vào container
WORKDIR /app
COPY . .

# Cài đặt và build Theia
RUN npm install -g @theia/cli && \
    npm install && \
    theia build && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 3000
CMD ["npx", "theia", "start", "/app", "--hostname=0.0.0.0"]
