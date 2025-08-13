FROM continuumio/anaconda3

RUN apt update && apt install -y \
    git \
    p7zip-full \
    ffmpeg \
    libsm6 \
    libxext6 \
    unzip

RUN cd /home && git clone https://github.com/neuralchen/SimSwap && cd SimSwap

SHELL ["/bin/bash", "-c"]

RUN conda create -n simswap python=3.8 -y

RUN /opt/conda/bin/conda run -n simswap pip install --no-cache-dir \
    torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cpu

RUN /opt/conda/bin/conda run -n simswap pip install --no-cache-dir \
    opencv-python==4.8.1.78 \
    opencv-contrib-python==4.8.1.78 \
    Pillow==10.0.1 \
    numpy==1.23.5 \
    scipy==1.10.1 \
    matplotlib==3.7.2 \
    scikit-image==0.21.0 \
    imageio==2.31.3 \
    imageio-ffmpeg==0.4.9 \
    tqdm==4.66.1

RUN /opt/conda/bin/conda run -n simswap pip install --no-cache-dir \
    insightface==0.2.1 \
    onnxruntime \
    moviepy

RUN sed -i 's/base/simswap/' ~/.bashrc
RUN sed -i "s/if len(self.opt.gpu_ids)/if torch.cuda.is_available() and len(self.opt.gpu_ids)/g" /home/SimSwap/options/base_options.py && \
    sed -i "s/device = torch.device('cuda:0')/torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')/g" /home/SimSwap/models/fs_model.py && \
    sed -i "s/torch.load(netArc_checkpoint)/torch.load(netArc_checkpoint) if torch.cuda.is_available() else torch.load(netArc_checkpoint, map_location=torch.device('cpu'))/g" /home/SimSwap/models/fs_model.py && \
    find /home/SimSwap -type f -exec sed -i "s/net.load_state_dict(torch.load(save_pth))/net.load_state_dict(torch.load(save_pth)) if torch.cuda.is_available() else net.load_state_dict(torch.load(save_pth, map_location=torch.device('cpu')))/g" {} \; && find /home/SimSwap -type f -exec sed -i "s/.cuda()/.to(torch.device('cuda:0' if torch.cuda.is_available() else 'cpu'))/g" {} \; && find /home/SimSwap -type f -exec sed -i "s/.to('cuda')/.to(torch.device('cuda:0' if torch.cuda.is_available() else 'cpu'))/g" {} \; && \
    sed -i "s/torch.device(\"cuda:0\")/torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')/g" /home/SimSwap/models/fs_model.py

WORKDIR /home/SimSwap
