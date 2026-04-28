#!/bin/bash
set -e

# --- Docker installieren ---
echo ">>> Docker installieren..."
sudo apt update && sudo apt install -y curl
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"

# --- Mosquitto Passwort einrichten ---
echo ">>> Mosquitto MQTT Benutzer einrichten..."
read -rp "MQTT Benutzername: " MQTT_USER
read -rsp "MQTT Passwort: " MQTT_PASS
echo ""

PASSWD_FILE="$(dirname "$0")/mosquitto/config/passwd"
sudo mkdir -p "$(dirname "$PASSWD_FILE")"
sudo docker run --rm eclipse-mosquitto:2 mosquitto_passwd -b /dev/stdout "$MQTT_USER" "$MQTT_PASS" | sudo tee "$PASSWD_FILE" > /dev/null
echo ">>> Passwortdatei erstellt."

# --- Home Assistant und Mosquitto starten ---
echo ">>> Dienste starten..."
cd "$(dirname "$0")"
sudo docker compose up -d

echo ""
echo ">>> Fertig!"
echo "    Home Assistant: http://$(hostname -I | awk '{print $1}'):8123"
echo "    MQTT Broker:    $(hostname -I | awk '{print $1}'):1883 (Benutzer: $MQTT_USER)"
