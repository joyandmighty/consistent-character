#!/bin/bash

export PYTHONUNBUFFERED=1

# Create workspace models directory if it doesn't exist
mkdir -p /workspace/models
mkdir -p /workspace/output
mkdir -p /workspace/input
mkdir -p /workspace/invokeai

# Link InvokeAI workspace
rsync -av /invokeai/ /workspace/invokeai/
rm -rf /invokeai
ln -sf /workspace/invokeai /invokeai

# Sync initial models from ComfyUI to workspace and remove original
rsync -av /ComfyUI/models/ /workspace/models/
rm -rf /ComfyUI/models
ln -sf /workspace/models /ComfyUI/models

# Sync initial input from ComfyUI to workspace and remove original
rsync -av /ComfyUI/input/ /workspace/input/
rm -rf /ComfyUI/input
ln -sf /workspace/input /ComfyUI/input

# Start filebrowser
filebrowser --address=0.0.0.0 --port=4040 --root=/ --noauth &

# Start Jupyter Notebook
jupyter notebook --ip=0.0.0.0 --port=8080 --allow-root --no-browser &

cd /ComfyUI || exit 1
python main.py --listen --port 3000 --output-directory /workspace/output --input-directory /workspace/input &

# Start InvokeAI
cd /invokeai || exit 1
invokeai-web --host 0.0.0.0 --port 9090 --root /invokeai &

# Start model downloads in the background
/download_models.sh &
