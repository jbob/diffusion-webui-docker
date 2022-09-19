#!/bin/sh

cd /home/diffusion/stable-diffusion-webui
. /home/diffusion/stable-diffusion-webui/venv/bin/activate
python3 webui.py --listen
