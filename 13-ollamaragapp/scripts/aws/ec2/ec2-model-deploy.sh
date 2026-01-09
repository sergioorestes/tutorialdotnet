# AWS EC2 instance
ssh -i "~/.ssh/ec2-keypair.pem" ubuntu@ec2-54-174-91-231.compute-1.amazonaws.com

# Type g4dn.xlarge
ec2-instance-selector --gpus 1 --cpu-architecture x86_64 -r us-east-1 \
  -o table-wide --max-results 10 --sort-by memory --sort-direction asc

# EC2 Firewall/Iptables
sudo ufw disable
sudo iptables -F && sudo iptables -P INPUT ACCEPT

sudo ufw allow 11434/tcp

# Ollama Server
sudo netstat -tulnp | grep :11434

curl -v ec2-54-174-91-231.compute-1.amazonaws.com:5000

# Deploy to remote Ollama Server
telnet ec2-54-174-91-231.compute-1.amazonaws.com 11434

export OLLAMA_HOST=54.174.91.231 && \
  ollama create mistral_7b_portuguese-unsloth -f "results/lora_model/Modelfile"

export OLLAMA_HOST=54.174.91.231 && \
  ollama create bert_tiny_embeddings_english_portuguese-unsloth -f "results/bert-tiny-embeddings-english-portuguese/Modelfile"

# Spitter tool
go version
go install github.com/sammcj/spitter/cmd/spitter@HEAD

# Spitter deploy model
telnet ec2-54-174-91-231.compute-1.amazonaws.com 11434

spitter mistral_7b_portuguese-unsloth:latest \
  http://ec2-54-174-91-231.compute-1.amazonaws.com:11434
