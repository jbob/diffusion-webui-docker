FROM nvidia/cuda:11.7.0-runtime-ubuntu22.04

# https://wiki.archlinux.org/title/docker#Run_GPU_accelerated_Docker_containers_with_NVIDIA_GPUs
# https://github.com/NVIDIA/nvidia-docker/wiki#can-i-use-the-gpu-during-a-container-build-ie-docker-build
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#daemon-configuration-file

ENV container=docker \
    LC_ALL=C \
    DEBIAN_FRONTEND=noninteractive \
    PIP_IGNORE_INSTALLED=0 \
    TORCH_COMMAND="pip install torch==1.12.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      wget \
      git \
      libgl1 \
      libglib2.0-0 \
      python3 \
      python3-pip \
      python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash diffusion
USER diffusion
WORKDIR /home/diffusion
COPY start.sh /home/diffusion/

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
    cd stable-diffusion-webui && \
    wget -qO GFPGANv1.3.pth 'https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth' && \
    wget -qO model.ckpt 'https://drive.yerf.org/wl/?id=EBfTrmcCCUAGaQBXVIj5lJmEhjoP1tgl&mode=grid&download=1' && \
    python3 -m venv "venv" && \
    . /home/diffusion/stable-diffusion-webui/venv/bin/activate && \
    sed -i 's/^start_webui()//' launch.py && \
    python3 launch.py

EXPOSE 7860/tcp
CMD /home/diffusion/start.sh
