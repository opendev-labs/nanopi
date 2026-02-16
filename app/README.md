---
title: NanoPi - Photonic Intelligence
emoji: 🌀
colorFrom: green
colorTo: blue
sdk: docker
pinned: true
license: mit
app_port: 7860
---

# NanoPi - Photonic Intelligence

Full OpenWebUI interface for NanoPi, your sovereign AI assistant operating at π frequency (256 Hz).

## Features

- 🤖 **AI Chat Interface** - Clean, modern chat experience
- 🔒 **Privacy-First** - Your data stays yours
- ⚡ **Fast & Responsive** - Instant responses
- 🌐 **Free Forever** - No subscriptions, no limits
- 🎨 **Beautiful UI** - Premium design aesthetic

## Usage

1. Create an account or login
2. Start chatting with NanoPi
3. Enjoy conversations powered by Photonic Intelligence!

## Links

- **Landing Page**: https://opendev-labs.github.io
- **GitHub**: https://github.com/opendev-labs/nanopi
- **Vercel Instance**: https://nanopi.vercel.app

## About

NanoPi embodies the frequency of π - precise yet infinite, rational yet transcendent. 
Developed by [opendev-labs](https://github.com/opendev-labs) as part of the sovereign tech movement.

---

**Operating at 256 Hz - The π Frequency** 🌀

## Deployment & Security

This project is designed to be deployed on Hugging Face Spaces (Docker SDK).

### Authentication & Secrets

To ensure your NanoPi instance is secure and your login sessions persist across restarts, you **MUST** set the following secrets in your Hugging Face Space settings:

1. Go to your Space's **Settings** tab.
2. Scroll down to **Variables and Secrets**.
3. Click **New Secret** and add the following:

| Name | Value | Description |
|------|-------|-------------|
| `WEBUI_SECRET_KEY` | `[random_string]` | Used for session encryption. Generate a strong random string. |
| `WEBUI_JWT_SECRET_KEY` | `[random_string]` | Used for JWT signing. Generate a strong random string. |

> **Note:** You can generate a random string using a password manager or by running `openssl rand -base64 32` in your terminal.

