FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# Setting Torch CUDA Alloc conf to mitigate potential GPU out-of-memory issues
ENV TORCH_CUDA_ALLOC_CONF=max_split_size_mb:64

# Copy startup scripts and grant execution permissions
COPY scripts/ /
RUN chmod +x /pre_start.sh /download_models.sh /install_custom_nodes.sh /install_comfy.sh

# Install Filebrowser and uv tool
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Install additional system packages and CUDNN
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    libcudnn8 libcudnn8-dev python3-venv rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a symbolic link for libcudnn_adv.so.9
RUN if [ -f /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.8 ]; then \
    ln -sf /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.8 /usr/lib/x86_64-linux-gnu/libcudnn_adv.so.9; \
    fi

# Copy the ComfyUI input data to a temporary location
COPY input/ /tmp/comfy_input

# Add version argument, label & file
ARG VERSION="dev"
ENV VERSION=$VERSION
LABEL org.opencontainers.image.version=${VERSION}
RUN echo $VERSION > VERSION

CMD [ "/start.sh" ]