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

# Ensure model is ready (Robust Runtime Check)
if ! ollama list | grep -q "opendev-labs/nanopi"; then
    echo "Model not found. Pulling opendev-labs/nanopi..."
    ollama pull opendev-labs/nanopi
else
    echo "Model opendev-labs/nanopi found."
fi

# Force absolute URL for backend to fix redirect loop
export WEBUI_URL=https://opendev-labs-nanopi.hf.space

# Fix CORS error - engineio rejects unknown origins
export ORIGINS="https://opendev-labs-nanopi.hf.space,https://opendev-labs.github.io,http://localhost:7860,http://0.0.0.0:7860"
export CORS_ALLOW_ORIGIN="https://opendev-labs-nanopi.hf.space,https://opendev-labs.github.io,http://localhost:7860,http://0.0.0.0:7860"

# Start Open WebUI 
export ENABLE_OAUTH_PERSISTENT_CONFIG="false"
# using the internal backend start script which is standard in the image
exec bash /app/backend/start.sh
