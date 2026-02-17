#!/bin/bash
# Start Ollama in background
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama to be ready
echo "Waiting for Ollama..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
    sleep 1
done
echo "Ollama is ready!"

# Ensure model is verified
ollama list

# Start Open WebUI 
# using the internal backend start script which is standard in the image
export WEBUI_URL=https://opendev-labs-nanopi.hf.space
exec bash /app/backend/start.sh
