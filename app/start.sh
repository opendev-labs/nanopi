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

# Auto-Update Mechanism: Always ensure we have the absolute latest model from Ollama Registry
echo "Checking for latest NanoPi model updates..."
ollama pull opendev-labs/nanopi

# ============================================================
# ONE-TIME ADMIN RESET
# Set RESET_ADMIN=true in HF Space Secrets to wipe all users.
# First person to sign up after restart becomes the new admin.
# IMPORTANT: Remove RESET_ADMIN secret after reset is done!
# ============================================================
if [ "$RESET_ADMIN" = "true" ]; then
  echo "[RESET] RESET_ADMIN=true detected. Wiping all users from database..."
  python3 -c "
import os, sys
database_url = os.environ.get('DATABASE_URL', '')
if not database_url.startswith('postgres'):
    print('[RESET] No Postgres DATABASE_URL found. Skipping.')
    sys.exit(0)
try:
    import psycopg2
    conn = psycopg2.connect(database_url)
    c = conn.cursor()
    # Wipe auth, users, and related session tables
    for table in ['auth', 'user', 'chat', 'chatidtag', 'tag', 'document', 'prompt', 'memory', 'tool', 'function', 'model', 'knowledge', 'usergroup']:
        try:
            c.execute(f'DELETE FROM \"{table}\"')
            print(f'[RESET] Cleared table: {table}')
        except Exception as te:
            print(f'[RESET] Skipped table {table}: {te}')
            conn.rollback()
    conn.commit()
    conn.close()
    print('[RESET] Done! All users wiped. First signup will be admin.')
    print('[RESET] ACTION REQUIRED: Remove the RESET_ADMIN secret from HF Space settings now!')
except Exception as e:
    print(f'[RESET] Failed: {e}')
"
fi
# ============================================================

# Network overrides handled before backend starts

# Hotfix to clean malformed custom WEBUI_URL protocol from Database
# Prevents redirect domain matching bugs when protocol is missing.
python3 -c "
import json, os

def fix_data(data):
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
    return data, updated

database_url = os.environ.get('DATABASE_URL')
if database_url and database_url.startswith('postgres'):
    try:
        import psycopg2
        conn = psycopg2.connect(database_url)
        c = conn.cursor()
        c.execute('SELECT id, data FROM config ORDER BY id DESC LIMIT 1')
        row = c.fetchone()
        if row:
            data = row[1]
            if isinstance(data, str):
                data = json.loads(data)
            data, updated = fix_data(data)
            if updated:
                c.execute('UPDATE config SET data = %s WHERE id = %s', (json.dumps(data), row[0]))
                conn.commit()
                print('Hotfixed Postgres DB WEBUI_URL')
        conn.close()
    except Exception as e:
        print('Postgres DB hotfix failed:', e)
else:
    try:
        import sqlite3
        db_path = '/app/backend/data/webui.db'
        if os.path.exists(db_path):
            conn = sqlite3.connect(db_path)
            c = conn.cursor()
            c.execute('SELECT id, data FROM config ORDER BY id DESC LIMIT 1')
            row = c.fetchone()
            if row:
                data = json.loads(row[1])
                data, updated = fix_data(data)
                if updated:
                    c.execute('UPDATE config SET data = ? WHERE id = ?', (json.dumps(data), row[0]))
                    conn.commit()
                    print('Hotfixed SQLite DB WEBUI_URL')
            conn.close()
    except Exception as e:
        print('SQLite DB hotfix failed:', e)
"

# Force absolute URL for backend to fix redirect loop
export WEBUI_URL="https://opendev-labs-nanopi.hf.space"

# Intercept and correct Hugging Face SPACE_HOST environment injection
# The internal start script overrides WEBUI_URL with SPACE_HOST which lacks https://
if [ -n "$SPACE_HOST" ]; then
    export SPACE_HOST="https://$SPACE_HOST"
fi

# Fix CORS error - engineio rejects unknown origins
export ORIGINS="https://opendev-labs-nanopi.hf.space"
export CORS_ALLOW_ORIGIN="https://opendev-labs-nanopi.hf.space"

# Start Open WebUI 
export ENABLE_OAUTH_PERSISTENT_CONFIG="false"
# using the internal backend start script which is standard in the image
exec bash /app/backend/start.sh
