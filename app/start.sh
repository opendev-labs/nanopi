#!/bin/bash
# Start Ollama in background
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama
sleep 5

# Start Open WebUI 
# using the internal backend start script which is standard in the image
exec bash /app/backend/start.sh
