#!/bin/bash

export PYTHONUNBUFFERED=1

# Run the installation script to set up ComfyUI and environment
if [ -x /install_comfy.sh ]; then
    /install_comfy.sh
else
    echo "install_comfy.sh not found or not executable"
    exit 1
fi

# Start filebrowser
filebrowser --address=0.0.0.0 --port=4040 --root=/ --noauth &

# Activate the virtual environment
source /workspace/venv/bin/activate

cd /workspace/ComfyUI || exit 1
python main.py --listen --port 3000 &

# Start model downloads in the background
/download_models.sh &
