#!/bin/bash
set -e

echo "Starting installation of ComfyUI and dependencies..."

# Create virtual environment under /workspace/venv
echo "Creating virtual environment..."
python3 -m venv /workspace/venv
source /workspace/venv/bin/activate
pip install --upgrade pip setuptools wheel

# Clone ComfyUI into /workspace/ComfyUI
echo "Cloning ComfyUI repository..."
rm -rf /workspace/ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

# Install ComfyUI requirements
echo "Installing ComfyUI requirements..."
cd /workspace/ComfyUI
pip install -r requirements.txt

# Setup ComfyUI Manager (custom nodes manager)
echo "Setting up ComfyUI Manager..."
mkdir -p custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
cd custom_nodes/ComfyUI-Manager
pip install -r requirements.txt
cd /workspace/ComfyUI

# Install custom nodes using external script
echo "Installing custom nodes..."
export CUSTOM_NODES_PATH="/workspace/ComfyUI/custom_nodes"
if [ -x /scripts/install_custom_nodes.sh ]; then
    /scripts/install_custom_nodes.sh
else
    echo "install_custom_nodes.sh not found or not executable"
fi

# Restore input files if backup exists
if [ -d /tmp/comfy_input ]; then
    echo "Restoring input files..."
    cp -r /tmp/comfy_input /workspace/ComfyUI/input
fi

echo "Installation complete." 