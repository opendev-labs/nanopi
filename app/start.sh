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
export ORIGINS="https://opendev-labs-nanopi.hf.space"
export CORS_ALLOW_ORIGIN="https://opendev-labs-nanopi.hf.space"

# Hotfix to clean malformed custom WEBUI_URL protocol from SQLite Database
# Prevents redirect domain matching bugs when protocol is missing.
python3 -c "
import sqlite3, json, os
db_path = '/app/backend/data/webui.db'
if os.path.exists(db_path):
    try:
        conn = sqlite3.connect(db_path)
        c = conn.cursor()
        c.execute('SELECT id, data FROM config ORDER BY id DESC LIMIT 1')
        row = c.fetchone()
        if row:
            data = json.loads(row[1])
            updated = False
            for path in [('ui', 'webui_url'), ('webui', 'url')]:
                if path[0] in data and path[1] in data[path[0]]:
                    val = data[path[0]][path[1]]
                    if val and not val.startswith('http'):
                        data[path[0]][path[1]] = 'https://' + val
                        updated = True
                        print('Hotfixed DB', path)
            if 'WEBUI_URL' in data:
                if data['WEBUI_URL'] and not data['WEBUI_URL'].startswith('http'):
                    data['WEBUI_URL'] = 'https://' + data['WEBUI_URL']
                    updated = True
                    print('Hotfixed DB WEBUI_URL')
            if updated:
                c.execute('UPDATE config SET data = ? WHERE id = ?', (json.dumps(data), row[0]))
                conn.commit()
        conn.close()
    except Exception as e:
        print('DB hotfix failed:', e)
"

# Start Open WebUI 
export ENABLE_OAUTH_PERSISTENT_CONFIG="false"
# using the internal backend start script which is standard in the image
exec bash /app/backend/start.sh
