FROM node:22-alpine

RUN apk add --no-cache git bash && \
    npm install -g code-server

WORKDIR /root/project
ENV PORT=8080
ENV PASSWORD=123456

EXPOSE 8080

CMD ["sh", "-c", "code-server /root/project --bind-addr 0.0.0.0:${PORT} --auth password"]
