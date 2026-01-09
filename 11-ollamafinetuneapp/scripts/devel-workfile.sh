# Tutorial ollamafinetuneapp
# Ollama Linux install
curl -fsSL https://ollama.com/install.sh | sh

sudo systemctl status ollama

# Ollama commands
ollama --version
ollama list

ls -la /usr/share/ollama/.ollama/models

# Models
ollama show phi4-mini
ollama show phi4-mini:latest --modelfile

# Custom unsloth model
ollama rm phi3.5-mini-instruct-bnb-4bit-unsloth
ollama create phi3.5-mini-instruct-bnb-4bit-unsloth -f Modelfile

ollama show phi3-mini-unsloth --modelfile
ollama run phi3-mini-unsloth

# Ollama local API
curl http://localhost:11434/api/push -d '{
  "model": "phi3-mini-unsloth"
}'

curl -X POST http://localhost:11434/api/generate -H "Content-Type: application/json" -d '{
  "model": "phi3-mini-unsloth",
  "prompt": "Ollama is 22 years old and is busy saving the world. Respond using JSON",
  "stream": false,
  "format": {
    "type": "object",
    "properties": {
      "conversations": {
        "type": "string"
      },
      "text": {
        "type": "string"
      }
    }
  }
}'

# Ollama server (API)
ollama serve
ollama run phi4-mini

# Generate a response
curl http://localhost:11434/api/generate -d '{
        "model": "phi4-mini",
        "prompt":"Why is the sky blue?"
    }'

# Chat with a model
curl http://localhost:11434/api/chat -d '{
        "model": "phi4-mini",
        "messages": [
            { "role": "user", "content": "why is the sky blue?" }
        ]
    }'

# Ollama Python packages
pip install llama-index-llms-ollama

# Install NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \  &&
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt install -y nvidia-container-toolkit

# Configure the container runtime
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Verify the Setup
docker pull nvidia/cuda:12.9.0-cudnn-devel-ubuntu24.04

sudo docker run --rm --gpus all \
    nvidia/cuda:12.9.0-cudnn-devel-ubuntu24.04 nvidia-smi

# Open WebUI install (GPU)
docker run -d -p 3000:8080 --gpus=all \
    -v /usr/share/ollama/.ollama:/root/.ollama \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always ghcr.io/open-webui/open-webui:ollama

docker ps --all

docker commit open-webui ghcr.io/open-webui/open-webui:ollama
docker container stop open-webui

# Open WebUI install (CPU)
docker run -d -p 3000:8080 \
    -v /usr/share/ollama/.ollama:/root/.ollama \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always ghcr.io/open-webui/open-webui:ollama

# Update Open WebUI
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower \
    --run-once open-webui

# Open WebUI (main)
sudo docker run -d --network=host \
    -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always ghcr.io/open-webui/open-webui:main

# Fine Tune Large Language Model (LLM) on a Custom Dataset with QLoRA
# Hugging Face
pip install -U "huggingface_hub[cli]"

huggingface-cli whoami
huggingface-cli delete-cache

# NVIDA environmentpip install torch==2.7.0
lsmod | grep nvidia

nvidia-smi

sudo kill -9 110721

python -c "import torch; print(torch.cuda.is_available())"

# Hugging Face Virtual Environment
sudo python3 -m venv /opt/py3venv
sudo chown -R $USER:$USER /opt/py3venv

source /opt/py3venv/bin/activate
python3 -m pip install --upgrade pip

pip install ipywidgets tqdm

# Cuda install
ubuntu-drivers devices

sudo apt install nvidia-cuda-toolkit

sudo apt install libaio-dev
sudo apt install libcufile-dev

nvcc --version
which nvcc

# Setup accelerate and deepspeed
accelerate config
accelerate env

nano ~/.cache/huggingface/accelerate/default_config.yaml

# Install Unsloth
pip install torch==2.7.0
pip install transformers[torch]

pip install huggingface-hub \
    xformers datasets trl peft bitsandbytes flash-attn

pip install protobuf==3.20.3 grpcio-status==1.48.2 \
    Pillow cut_cross_entropy hf_transfer msgspec sentencepiece tyro wheel

pip install -U unsloth==2025.06.08 unsloth-zoo==2025.06.08

pip uninstall unsloth unsloth_zoo -y &&
    pip install --no-deps git+https://github.com/unslothai/unsloth_zoo.git &&
    pip install --no-deps git+https://github.com/unslothai/unsloth.git

pip install unsloth &&
    pip uninstall unsloth -y &&
    pip install --upgrade --no-cache-dir --no-deps git+https://github.com/unslothai/unsloth.git

# Install GGUF
pip install gguf==0.17.1

# Freeze Virtal Environment.
pip freeze > ./requirements.txt

# Llama.cpp manual Saving to GGUF
sudo apt install -y pciutils build-essential cmake curl libcurl4-openssl-dev

git clone https://github.com/ggerganov/llama.cpp
git clone --single-branch --branch b5846 https://github.com/ggerganov/llama.cpp

# Llama.cpp build
rm -rf llama.cpp/build &&
    /usr/bin/cmake llama.cpp -B llama.cpp/build \
        -DCMAKE_CUDA_HOST_COMPILER=/usr/bin/g++-11 \
        -DCMAKE_CUDA_COMPILER=/usr/bin/nvcc \
        -DBUILD_SHARED_LIBS=OFF -DGGML_CCACHE=OFF -DGGML_CUDA=ON -DLLAMA_CURL=ON \
        -DCMAKE_EXE_LINKER_FLAGS="-Wl,-Bdynamic -lm" &&
    /usr/bin/cmake --build llama.cpp/build --config Release --clean-first -j8 \
        --target llama-quantize llama-cli llama-gguf-split llama-mtmd-cli &&
    cp llama.cpp/build/bin/llama-* llama.cpp

# Llama.cpp python installation
sudo apt install gcc-11 g++-11

sudo update-alternatives --remove gcc /usr/bin/gcc-11
sudo update-alternatives \
    --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-11

pip install llama-cpp-python --upgrade --force-reinstall --no-cache-dir --verbose \
    -C cmake.args="-DGGML_CUDA=ON -DLLAMA_CURL=ON"

# Llama.cpp execution
python llama.cpp/convert_lora_to_gguf.py results/lora_model \
    --outfile results/output_file.gguf --outtype q8_0

# Jupyter notebook
pip install jupyter jupyterlab

# Run script
jupyter notebook ollama_unsloth_guanaco_finetuning.ipynb

export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True &&
    accelerate launch ollama_unsloth_guanaco_finetuning.py
