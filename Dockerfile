FROM codercom/code-server:latest

# Xóa entrypoint gốc để tránh lỗi -c
ENTRYPOINT []

ENV PASSWORD=123456
ENV PORT=8080

EXPOSE 8080

CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "--password", "123456"]
