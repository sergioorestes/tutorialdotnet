# Tutorial ollamahagapp
# Hugging Face
huggingface-cli whoami
huggingface-cli delete-cache

rm -rf ~/.cache/huggingface/datasets/*

# Python pacakges
pip install llama-index \
  llama-index-readers-file pymupdf \
  llama-index-vector-stores-postgres \
  llama-index-vector-stores-faiss \
  llama-index-embeddings-huggingface \
  llama-index-llms-llama-cpp

pip install llama-cpp-python
pip install faiss-cpu python-dotenv

# PostgreSQL AI plugin
pip install pgai

# Llama.cpp execution
python llama.cpp/convert_hf_to_gguf.py results/bert-tiny-embeddings-english-portuguese \
  --outfile results/bert-tiny-embeddings-english-portuguese/unsloth.Q8_0.gguf --outtype q8_0

# Ollama commands
ollama list

# Ollama import model from Huggung Face
ls -la ~/.cache/huggingface/hub/

huggingface-cli download cnmoro/bert-tiny-embeddings-english-portuguese

cd results/local_model && \
  GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/cnmoro/bert-tiny-embeddings-english-portuguese

git clone https://huggingface.co/cnmoro/bert-tiny-embeddings-english-portuguese

# Open WebUI docker
docker run -d --network local-rag -p 3000:8080 \
    -v /usr/share/ollama/.ollama:/root/.ollama \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always ghcr.io/open-webui/open-webui:ollama

docker commit open-webui ghcr.io/open-webui/open-webui:ollama

# Deploy Ollama Server remote
export OLLAMA_HOST=54.174.91.231 && \
  ollama create bert_tiny_embeddings_english_portuguese-unsloth -f "results/bert-tiny-embeddings-english-portuguese/Modelfile"

# Ollama local API
# Generate a embed conversation
curl -X POST http://localhost:11434/api/generate -H "Content-Type: application/json" -d '{
  "model": "mistral_7b_portuguese-unsloth:latest",
  "prompt": "Qual o CNPJ da Drogaria Campeã?",
  "stream": false
}'

# Postgres Vector docker
docker pull pgvector/pgvector:pg17

docker run -d --publish 5432:5432 \
  --name pg-vector \
  -e POSTGRES_PASSWORD=postgres \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v /home/user/projects/tutorialdotnet/13-ollamaragapp/data:/var/lib/postgresql/data/pgdata \
  --restart always pgvector/pgvector:pg17

docker commit pg-vector pgvector/pgvector:pg17

# Setting up PostgreSQL
docker network create local-rag
docker pull timescale/timescaledb-ha:pg17

# -p 5432:5432
docker run -d --network=host --name timescaledb \
  -e POSTGRES_PASSWORD=postgres timescale/timescaledb-ha:pg17

docker commit timescaledb timescale/timescaledb-ha:pg17
