FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04 AS base

# Add version argument and label
ARG VERSION="dev"
LABEL org.opencontainers.image.version=${VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set working directory and environment variables
ENV SHELL=/bin/bash
ENV PYTHONUNBUFFERED=True
ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION=$VERSION

# Setting Torch CUDA Alloc conf to mitigate potential GPU out-of-memory issues
ENV TORCH_CUDA_ALLOC_CONF=max_split_size_mb:64

WORKDIR /

# Install system packages, NVIDIA cuDNN libraries, and Python dependencies
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt-get install --yes --no-install-recommends \
    git wget curl bash libgl1 software-properties-common openssh-server nginx rsync \
    build-essential gcc g++ python3-apt && \
    # Install system-level cuDNN libraries; note: PyTorch wheels include their own cuDNN but these are needed by other components
    apt-get install -y --no-install-recommends libcudnn8 libcudnn8-dev && \
    # Ensure apt_pkg is correctly linked
    cd /usr/lib/python3/dist-packages && \
    ln -s apt_pkg.cpython-*.so apt_pkg.so && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-venv \
    python3.12-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Create a symbolic link for libcudnn_adv.so.9 required by some libraries (e.g., ONNX Runtime)
RUN if [ -f /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.8 ]; then \
    ln -sf /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.8 /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.9; \
    else \
    echo "Warning: libcudnn_adv.so.8 not found; please verify cuDNN installation"; \
    fi

# Set up Python and pip
RUN if [ -L /usr/bin/python ]; then rm /usr/bin/python; fi && \
    ln -s /usr/bin/python3.12 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.12 /usr/bin/python3 && \
    curl -fsSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Create and activate virtual environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Upgrade pip and install essential Python packages
RUN pip install --upgrade --no-cache-dir pip setuptools wheel

# Install main Python dependencies in correct order
RUN pip install --upgrade --no-cache-dir \
    huggingface_hub diffusers \
    torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124 \
    xformers

# Install additional dependencies for StreamDiffusion and others
RUN pip install --upgrade --no-cache-dir \
    tensorrt nvidia-pyindex nvidia-tensorrt streamdiffusion

# Clone and set up ComfyUI and ComfyUI Manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd /ComfyUI && \
    pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    pip install -r requirements.txt

# Install Filebrowser utility
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Install uv tool
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set up NGINX Proxy
COPY proxy/nginx.conf /etc/nginx/nginx.conf
COPY proxy/readme.html /usr/share/nginx/html/readme.html
COPY README.md /usr/share/nginx/html/README.md

# Copy the ComfyUI data
# NOTE: Ensure that required model files (e.g., "4x‑ClearRealityV1.pth") and assets (e.g., "naistyles.csv")
# are provided in the correct directories or via mounted volumes
COPY input/ /ComfyUI/input/

# Copy startup scripts and grant execution permissions
COPY scripts/ /
RUN chmod +x /start.sh /pre_start.sh /download_models.sh /install_custom_nodes.sh

RUN /install_custom_nodes.sh

# Write version info
RUN echo $VERSION > VERSION

# Set default command to start the application
CMD [ "/start.sh" ]