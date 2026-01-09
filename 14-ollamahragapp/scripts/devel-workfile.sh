# Tutorial ollamahragapp
# Python packages
sudo apt-get install libpq-dev

pip install --upgrade pip
pip install timescale-vector --use-pep517 --no-build-isolation

pip install get_settings
pip install llama-index llama-index llama-index-embeddings-ollama

# PostgreSQL commands
psql -d "postgres://postgres:postgres@localhost:5432/postgres" \
  -c "CREATE EXTENSION IF NOT EXISTS vectorscale CASCADE;"

# AWS EC2 instance
ssh -i "~/.ssh/ec2-keypair.pem" \
  ubuntu@ec2-54-174-91-231.compute-1.amazonaws.com

# Open WebUI docker
docker run -d --network=host \
    -v /usr/share/ollama/.ollama:/root/.ollama \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always ghcr.io/open-webui/open-webui:ollama

docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower \
    --run-once open-webui

# Setting up PgVectorScale
docker pull timescale/timescaledb-ha:pg17

docker run -d --name timescaledb --network=host \
  -e POSTGRES_PASSWORD=postgres \
  -e PGDATA=/var/lib/postgresql/data \
  -v /home/user/projects/tutorialdotnet/14-ollamahragapp/data:/var/lib/postgresql/data \
  --restart always timescale/timescaledb-ha:pg17

docker exec -it timescaledb /bin/bash
docker commit timescaledb timescale/timescaledb-ha:pg17

# Test Models
# Ollama remote API
curl -X POST http://54.174.91.231:11434/api/embed -d '{
  "model": "bert_tiny_embeddings_english_portuguese-unsloth:latest",
  "input": "Qual o CNPJ da Drogaria Campeã da Lapa?"
}'

curl -X POST http://54.174.91.231:11434/api/generate -H "Content-Type: application/json" -d '{
  "model": "mistral_7b_portuguese-unsloth:latest",
  "prompt": "Qual o CNPJ da Drogaria Campeã da Lapa?",
  "stream": false
}'

