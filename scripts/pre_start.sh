#!/bin/bash

export PYTHONUNBUFFERED=1

# Create workspace directories if they don't exist
mkdir -p /workspace/models
mkdir -p /workspace/output
mkdir -p /workspace/input
mkdir -p /workspace/venv

# Copy venv to workspace
tar -C /venv -cf - . | tar -C /workspace/venv -xf - > /dev/null 2>&1
rm -rf /venv

# Copy ComfyUI directory to workspace
tar -C /ComfyUI -cf - . | tar -C /workspace/ComfyUI -xf - > /dev/null 2>&1
rm -rf /ComfyUI

# Start filebrowser
filebrowser --address=0.0.0.0 --port=4040 --root=/ --noauth &

# Activate the virtual environment
source /workspace/venv/bin/activate

cd /workspace/ComfyUI || exit 1
python main.py --listen --port 3000 &

# Start model downloads in the background
/download_models.sh &
