# Sử dụng Ubuntu 22.04 làm ảnh cơ sở
FROM ubuntu:22.04

# Thiết lập biến môi trường để tránh tương tác khi cài đặt gói
ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt Python 3.12 và các công cụ Linux cần thiết
RUN apt-get update && \
    # 1. Thêm PPA để cài Python 3.12
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    \
    # 2. Cài đặt Python 3.12 và các công cụ phát triển/Hệ thống (Dev/System Tools)
    apt-get install -y \
        python3.12 \
        python3.12-dev \
        python3.12-venv \
        python3-pip \
        curl \
        git \
        build-essential \
        # Tools Linux bổ sung
        # Phân tích & Gỡ lỗi (Debugging & Analysis)
        htop \
        less \
        procps \
        strace \
        # Mạng (Networking)
        net-tools \
        iproute2 \
        dnsutils \
        telnet \
        # Quản lý tệp (Filesystem & Archiving)
        tree \
        unzip \
        zip \
        tar \
        # Soạn thảo văn bản (Editing)
        nano \
        vim \
        # Tiện ích khác
        wget \
        && \
    \
    # 3. Dọn dẹp
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Thiết lập 'python3.12' làm lệnh 'python' và 'pip' mặc định
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Cài đặt JupyterLab và các gói phổ biến khác
RUN pip install --no-cache-dir \
    jupyterlab \
    notebook \
    pandas \
    numpy \
    matplotlib \
    --break-system-packages && \
    rm -rf /root/.cache/pip

# Copy entrypoint và cấp quyền thực thi
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Mở cổng JupyterLab
EXPOSE 8888

USER root

# Thiết lập điểm vào container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
