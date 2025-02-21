FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04 AS base

# Add version argument and label
ARG VERSION="dev"
LABEL org.opencontainers.image.version=${VERSION}

# Setting Torch CUDA Alloc conf to mitigate potential GPU out-of-memory issues
ENV TORCH_CUDA_ALLOC_CONF=max_split_size_mb:64
ENV VERSION=$VERSION

WORKDIR /

# Install additional system packages and CUDNN
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    libcudnn8 libcudnn8-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a symbolic link for libcudnn_adv.so.9
RUN if [ -f /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.8 ]; then \
    ln -sf /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.8 /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.9; \
    fi

# Install additional Python dependencies
RUN pip install --upgrade --no-cache-dir \
    huggingface_hub diffusers \
    xformers tensorrt nvidia-pyindex nvidia-tensorrt streamdiffusion

# Clone and set up ComfyUI and ComfyUI Manager
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd /ComfyUI && \
    pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    pip install -r requirements.txt

# Install Filebrowser and uv tool
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Set up NGINX Proxy
COPY README.md /usr/share/nginx/html/README.md

# Copy the ComfyUI data
COPY input/ /ComfyUI/input/

# Copy startup scripts and grant execution permissions
COPY scripts/ /
RUN chmod +x /start.sh /pre_start.sh /download_models.sh /install_custom_nodes.sh

RUN /install_custom_nodes.sh

# Write version info
RUN echo $VERSION > VERSION

CMD [ "/start.sh" ]