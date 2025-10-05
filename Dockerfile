# Dùng image chính thức của code-server
FROM codercom/code-server:latest

# Cài thêm tiện ích nếu muốn
USER root
RUN apt-get update && apt-get install -y git curl wget sudo && \
    rm -rf /var/lib/apt/lists/*

# Tạo user (Render không thích chạy dưới root)
RUN useradd -m -s /bin/bash coder && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy config khởi động
USER coder
WORKDIR /home/coder

# Tạo thư mục mặc định
RUN mkdir -p /home/coder/project

# Mở port Render yêu cầu
EXPOSE 8080

# Render sẽ tự gán $PORT, nên ta bind vào đó
ENV PORT=8080
ENV PASSWORD=yourpassword

# CMD chạy VSCode web
CMD ["sh", "-c", "code-server /home/coder/project --bind-addr 0.0.0.0:${PORT} --auth password"]
