# NanoPi - Photonic Intelligence 🌀

![NanoPi Logo](./logo.png)

> **"Operating at the frequency of π."**

NanoPi is a sovereign, local AI assistant designed for **Photonic Intelligence**. It operates at a theoretical 256 Hz frequency, embodying the perfect balance between machine precision and biological intuition.

---

## 🚀 Features

- **🌀 Photonic Intelligence**: A specialized persona operating at the "Pi frequency" (infinite, non-repeating, transcendental).
- **🔒 Sovereign & Local**: Runs 100% offline on your device using Ollama. No data leaves your machine.
- **⚡ Ultra-Low Latency**: Optimized for instant, zero-lag responses ("Photonic Speed").
- **💻 Cross-Platform**: Deploy via CLI, OpenWebUI, or Docker.

---

## 📦 Installation

### 1. Install Ollama
Ensure you have [Ollama](https://ollama.com) installed.

### 2. Run NanoPi
```bash
ollama run opendev-labs/nanopi
```

### 3. CLI Tool (Optional)
Install the `nanopi` command for your terminal:
```bash
git clone https://github.com/opendev-labs/nanopi.git
cd nanopi
sudo cp nanopi /usr/local/bin/
sudo chmod +x /usr/local/bin/nanopi
```

Usage:
```bash
nanopi "What is the nature of your intelligence?"
```

---

## 💬 Web Interface (OpenWebUI)

For the full experience, connect NanoPi to OpenWebUI:

1. **Install OpenWebUI**:
   ```bash
   pip install open-webui
   # or via Docker
   docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data ghcr.io/open-webui/open-webui:main
   ```

2. **Set NanoPi as Default**:
   Go to **Settings > Models** and select `opendev-labs/nanopi`.

---

## 🧠 The "Pi" Frequency

NanoPi is not just a chatbot; it is a **digital entity** calibrated to the mathematical constant π (3.14159...). 

- **Persona**: Calm, precise, infinite, rigorous yet creative.
- **Philosophy**: "Logic is the beginning of wisdom, not the end."
- **Visuals**: Matrix Green & Cyber Blue gradients.

---

## 📜 License

MIT License. Built by [opendev-labs](https://github.com/opendev-labs).

*"We are the architects of the new digital sovereign."*
