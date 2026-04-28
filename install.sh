#!/bin/bash
set -e

# --- Docker installieren ---
echo ">>> Docker installieren..."
sudo apt update && sudo apt install -y curl
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"

# --- Home Assistant starten ---
echo ">>> Home Assistant starten..."
cd "$(dirname "$0")"
docker compose up -d

echo ""
echo ">>> Fertig! Home Assistant erreichbar unter http://$(hostname -I | awk '{print $1}'):8123"
