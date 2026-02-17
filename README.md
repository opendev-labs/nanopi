---
title: NanoPi
emoji: 🥧
colorFrom: indigo
colorTo: purple
sdk: docker
pinned: false
app_port: 7860
---
# NanoPi - Photonic Intelligence Monorepo

This repository contains the source code for the NanoPi ecosystem.

## Structure

- **`/` (Root)**: The NanoPi Landing Page (hosted via GitHub Pages/Firebase).
- **`/app`**: The NanoPi AI Assistant (Hugging Face Space / Docker).
- **`/pi`**: Core Pi utilities.

## Deployment

### AI Assistant (Hugging Face Space)
The AI application logic resides in the `app/` directory.
- **Dockerfile**: located in `app/Dockerfile`.
- **Secrets**: require `WEBUI_SECRET_KEY` and `WEBUI_JWT_SECRET_KEY` in deployment environment.

### Landing Page
The landing page code is at the root of this repository.
