#!/bin/bash
set -e

# Initialize the state lock file in /workspace
STATE_LOCK="/workspace/state.lock"
if [ ! -f "$STATE_LOCK" ]; then
  touch "$STATE_LOCK"
fi

# Check if installation is already complete
if grep -q "INSTALL_COMPLETE=1" "$STATE_LOCK"; then
  echo "Installation already complete, skipping execution."
  exit 0
fi

# Step 1: Python environment setup and dependency installation
if grep -q "PYTHON_SETUP=1" "$STATE_LOCK"; then
  echo "Python environment already set up, skipping..."
else
  echo "Creating virtual environment..."
  python3 -m venv /workspace/venv
  source /workspace/venv/bin/activate
  pip install --upgrade pip setuptools wheel

  echo "Installing additional Python dependencies..."
  pip install --no-cache-dir --no-build-isolation huggingface_hub diffusers xformers streamdiffusion
  pip install --no-cache-dir nvidia-pyindex nvidia-tensorrt

  echo "PYTHON_SETUP=1" >> "$STATE_LOCK"
fi

# Step 2: ComfyUI and Manager setup
if grep -q "COMFYUI_SETUP=1" "$STATE_LOCK"; then
  echo "ComfyUI and Manager setup already completed, skipping..."
else
  echo "Cloning ComfyUI repository..."
  rm -rf /workspace/ComfyUI
  git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

  echo "Installing ComfyUI requirements..."
  cd /workspace/ComfyUI
  pip install -r requirements.txt

  echo "Setting up ComfyUI Manager..."
  mkdir -p custom_nodes
  git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
  cd custom_nodes/ComfyUI-Manager
  pip install -r requirements.txt
  cd /workspace/ComfyUI

  echo "COMFYUI_SETUP=1" >> "$STATE_LOCK"
fi

# Step 3: Custom nodes installation
if grep -q "CUSTOM_NODES_SETUP=1" "$STATE_LOCK"; then
  echo "Custom nodes installation already completed, skipping..."
else
  echo "Installing custom nodes..."
  CUSTOM_NODES_PATH="/workspace/ComfyUI/custom_nodes"
  if [ -x /scripts/install_custom_nodes.sh ]; then
      /install_custom_nodes.sh "$CUSTOM_NODES_PATH"
  else
      echo "install_custom_nodes.sh not found or not executable"
  fi
  echo "CUSTOM_NODES_SETUP=1" >> "$STATE_LOCK"
fi

# Restore input files if backup exists
if [ -d /tmp/comfy_input ]; then
  echo "Restoring input files..."
  cp -r /tmp/comfy_input /workspace/ComfyUI/input
fi

echo "Installation complete."
echo "INSTALL_COMPLETE=1" >> "$STATE_LOCK" 