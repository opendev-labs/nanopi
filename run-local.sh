#!/bin/bash
# ============================================================
#  NanoPi — Run Space Locally via Docker
#  Usage: ./run-local.sh [port]   (default port: 7860)
# ============================================================

set -e

PORT="${1:-7860}"
IMAGE_NAME="nanopi-local"
CONTAINER_NAME="nanopi"

# ── Colours ──────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}[NanoPi]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ── Prereqs ──────────────────────────────────────────────────
command -v docker &>/dev/null || error "Docker is not installed or not in PATH."

# ── Stop any running instance ─────────────────────────────────
if docker ps -q --filter "name=^${CONTAINER_NAME}$" | grep -q .; then
    warn "Container '${CONTAINER_NAME}' is already running. Stopping it..."
    docker stop "${CONTAINER_NAME}" && docker rm "${CONTAINER_NAME}"
fi

# ── Build image ───────────────────────────────────────────────
info "Building Docker image '${IMAGE_NAME}' from $(pwd)/Dockerfile ..."
docker build \
    --build-arg CACHE_BUST="$(date +%s)" \
    -t "${IMAGE_NAME}" \
    "$(dirname "$0")"

# ── Run container ─────────────────────────────────────────────
info "Starting NanoPi on http://localhost:${PORT} ..."

docker run -d \
    --name "${CONTAINER_NAME}" \
    -p "${PORT}:7860" \
    -e PORT=7860 \
    -e HOST=0.0.0.0 \
    -e WEBUI_URL="http://localhost:${PORT}" \
    -e ORIGINS="http://localhost:${PORT}" \
    -e CORS_ALLOW_ORIGIN="http://localhost:${PORT}" \
    -e OLLAMA_BASE_URL="http://127.0.0.1:11434" \
    -e WEBUI_NAME="NanoPi" \
    -e WEBUI_SUBTITLE="Photonic Intelligence" \
    -e DEFAULT_MODELS="opendev-labs/nanopi" \
    -e ENABLE_OAUTH_SIGNUP="false" \
    -e ENABLE_OAUTH_PERSISTENT_CONFIG="false" \
    -e WEBUI_AUTH="false" \
    -e SCARF_NO_ANALYTICS=true \
    -v nanopi-data:/app/backend/data \
    "${IMAGE_NAME}"

# ── Tail logs  ───────────────────────────────────────────────
info "Container started (name: ${CONTAINER_NAME}). Streaming logs — Ctrl+C to detach."
info "Open WebUI will be available at: http://localhost:${PORT}"
echo ""
docker logs -f "${CONTAINER_NAME}"
