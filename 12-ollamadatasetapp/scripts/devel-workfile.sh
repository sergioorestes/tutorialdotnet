# Tutorial ollamadatasetapp
# Hugging Face
huggingface-cli whoami
huggingface-cli delete-cache

rm -rf ~/.cache/huggingface/datasets/*

df -h
du -a | sort -n -r | head -n 5

# Llama.cpp manual Saving to GGUF
git clone https://github.com/ggerganov/llama.cpp
git clone --single-branch --branch b5937 https://github.com/ggerganov/llama.cpp

# Llama.cpp build
rm -rf llama.cpp/build &&
    /usr/bin/cmake llama.cpp -B llama.cpp/build \
        -DCMAKE_CUDA_HOST_COMPILER=/usr/bin/g++-12 \
        -DCMAKE_CUDA_COMPILER=/usr/bin/nvcc \
        -DBUILD_SHARED_LIBS=OFF -DGGML_CCACHE=OFF -DGGML_CUDA=ON -DLLAMA_CURL=ON \
        -DCMAKE_EXE_LINKER_FLAGS="-Wl,-Bdynamic -lm" &&
    /usr/bin/cmake --build llama.cpp/build --config Release --clean-first -j8 \
        --target llama-quantize llama-cli llama-gguf-split llama-mtmd-cli &&
    cp llama.cpp/build/bin/llama-* llama.cpp

pip install llama-cpp-python --upgrade --force-reinstall --no-cache-dir --verbose \
    -C cmake.args="-DGGML_CUDA=ON -DLLAMA_CURL=ON"

pip install trl==0.19.1
pip install mistral_inference --use-pep517

# Llama.cpp execution
python llama.cpp/convert_hf_to_gguf.py results/lora_model \
    --outfile results/lora_model/unsloth.Q8_0.gguf --outtype q8_0

# Run script
jupyter notebook ollama_unsloth_alpaca_finetuning.ipynb

# Install Augmentoolkit
sudo mkdir augmentoolkit
sudo chown -R $USER:$USER /opt/augmentoolkit

git clone https://github.com/e-p-armstrong/augmentoolkit.git
cd augmentoolkit

bash local_linux.sh small

# Augmentoolkit compiler
sudo apt install gcc-12 g++-11

sudo update-alternatives --config gcc

sudo update-alternatives --remove gcc /usr/bin/gcc-11
sudo update-alternatives \
  --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-11

# Alpaca-style Dataset Generator
sudo mkdir /opt/alpaca-dataset-generator
sudo chown -R $USER:$USER /opt/alpaca-dataset-generator

git clone https://github.com/ekatraone/alpaca-dataset-generator.git
cd alpaca-dataset-generator

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt
python -m nltk.downloader punkt stopwords

python src/main.py --num_examples 1000

# Symlink to folder
rm alpaca-dataset-generator
ln -s /opt/alpaca-dataset-generator alpaca-dataset-generator

# Ollama commands
ollama list

ollama pull cnmoro/mistral_7b_portuguese:q8_0
ollama rm mistral_7b_portuguese-unsloth:latest

ls -la /usr/share/ollama/.ollama/models

# Ollama local API
# Send a generate request
curl -X POST http://localhost:11434/api/generate -H "Content-Type: application/json" -d '{
  "model": "mistral_7b_portuguese-unsloth:latest",
  "prompt": "Qual o CNPJ da Drogaria Campeã?",
  "stream": false
}'

# Deploy Ollama Server remote
export OLLAMA_HOST=54.174.91.231 && \
  ollama create mistral_7b_portuguese-unsloth -f "results/lora_model/Modelfile"

# Start vLLM Local
export CUDA_LAUNCH_BLOCKING=1 &&
export TORCH_CUDA_ARCH_LIST="8.6" && export TORCH_NCCL_AVOID_RECORD_STREAMS=0 &&
export VLLM_USE_FLASHINFER_SAMPLER=0 && export VLLM_USE_TRTLLM_ATTENTION=1 &&
export VLLM_USE_TRTLLM_DECODE_ATTENTION=1 && export VLLM_DISABLE_FLASHINFER=1 &&
  vllm serve --config config/vllm/config.yaml
