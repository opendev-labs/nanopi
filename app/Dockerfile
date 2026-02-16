FROM ghcr.io/open-webui/open-webui:main

# 1. Install Dependencies & Python Tools
RUN apt-get update && apt-get install -y curl procps git python3-pip && rm -rf /var/lib/apt/lists/*

# 2. Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# 3. Pull Official NanoPi Model
# Move Modelfile to build context (Optional, keeping for reference/fallback)
COPY Modelfile /root/Modelfile

# Start Ollama, Pull Model
RUN ollama serve & \
    OLLAMA_PID=$! && \
    sleep 10 && \
    ollama pull opendev-labs/nanopi && \
    kill $OLLAMA_PID

# 4. Pre-download Embedding Model (Optimization)
# Fixes timeout by baking model into image
RUN python3 -c "import os; from huggingface_hub import snapshot_download; snapshot_download('sentence-transformers/all-MiniLM-L6-v2', cache_dir='/app/backend/data/cache/embedding/models')"

# 5. Environment Variables
# FIX: WEBUI_URL is crucial for OAuth redirects to work correctly in Spaces
ENV WEBUI_URL=https://opendev-labs-nanopi.hf.space
# FIX: Allow the Space domain as an origin to prevent CORS/Redirect issues
ENV ORIGINS="https://opendev-labs-nanopi.hf.space,http://localhost:7860,http://0.0.0.0:7860"
# FIX: Force Open WebUI to use environment variables for OAuth instead of database config
ENV ENABLE_OAUTH_PERSISTENT_CONFIG="false"
ENV OLLAMA_BASE_URL=http://127.0.0.1:11434
ENV WEBUI_NAME="NanoPi"
ENV WEBUI_SUBTITLE="Photonic Intelligence"
ENV DEFAULT_MODELS="opendev-labs/nanopi"
ENV SHOW_ADMIN_DETAILS="false"
ENV ENABLE_SIGNUP="true"
ENV ENABLE_COMMUNITY_SHARING="false"
# FIX: Bind to all interfaces for HF Spaces
ENV HOST=0.0.0.0
ENV FORWARDED_ALLOW_IPS='*'
ENV PORT=7860
# FIX: Start Script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# FIX: CORS and Security
ENV CORS_ALLOW_ORIGIN="https://opendev-labs-nanopi.hf.space,http://localhost:7860,http://0.0.0.0:7860"

# IMPORTANT: The following secrets MUST be set in the Hugging Face Space Settings (Repository > Settings > Variables and Secrets)
# Do NOT hardcode them here for production/public spaces.
# ENV WEBUI_SECRET_KEY="your-secret-key-here"
# ENV WEBUI_JWT_SECRET_KEY="your-jwt-secret-key-here"

CMD ["/app/start.sh"]
