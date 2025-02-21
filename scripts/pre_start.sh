#!/bin/bash

export PYTHONUNBUFFERED=1

# Create workspace directories if they don't exist
mkdir -p /workspace/models
mkdir -p /workspace/output
mkdir -p /workspace/input
mkdir -p /workspace/venv

# Copy venv to workspace and update symlinks
rsync -av /venv/ /workspace/venv/
rm -rf /venv
ln -sf /workspace/venv /venv

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


# Activate the virtual environment
source /workspace/venv/bin/activate

cd /ComfyUI || exit 1
python main.py --listen --port 3000 --output-directory /workspace/output --input-directory /workspace/input &

# Start model downloads in the background
/download_models.sh &
