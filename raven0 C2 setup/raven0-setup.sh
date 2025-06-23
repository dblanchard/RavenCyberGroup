#!/bin/bash
# raven0-setup.sh
# C2 host setup script for Raven0 — installs Docker, Tailscale, ntfy, Grafana, and dashboard

set -euo pipefail

# -----------------------------
# Configurable Variables
# -----------------------------
TAILSCALE_AUTH_KEY="tskey-xxxxxxxxxxxxxxxx"   # Replace this
DOMAIN="ntfy.ravencybergroup.com"
EMAIL="duaneleeblanchard@gmail.com"            # For Let's Encrypt cert

# -----------------------------
# System Preparation
# -----------------------------
echo "[+] Updating and installing dependencies"
apt update && apt upgrade -y
apt install -y curl gnupg2 software-properties-common ca-certificates lsb-release ufw unzip

# -----------------------------
# Install Docker
# -----------------------------
echo "[+] Installing Docker"
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker

# -----------------------------
# Install Docker Compose
# -----------------------------
DOCKER_COMPOSE_VERSION="2.20.2"
echo "[+] Installing Docker Compose v$DOCKER_COMPOSE_VERSION"
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-linux-aarch64 -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# -----------------------------
# Enable Firewall
# -----------------------------
echo "[+] Configuring UFW firewall"
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw --force enable

# -----------------------------
# Install and Join Tailscale
# -----------------------------
echo "[+] Installing Tailscale"
apt install -y tailscale
systemctl enable --now tailscaled
sleep 3
tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname "raven0" --advertise-tags=tag:c2 --ssh

# -----------------------------
# Docker Compose Services
# -----------------------------
echo "[+] Writing docker-compose.yml"
mkdir -p /opt/raven0 && cd /opt/raven0

cat <<EOF > docker-compose.yml
version: '3.8'

services:
  ntfy:
    image: binwiederhier/ntfy
    container_name: ntfy
    restart: always
    volumes:
      - ./ntfy/cache:/var/cache/ntfy
      - ./ntfy/config:/etc/ntfy
    ports:
      - "80:80"
      - "443:443"
    environment:
      - NTFY_BASE_URL=https://$DOMAIN
      - NTFY_BEHIND_PROXY=true
    labels:
      - "traefik.enable=true"

  dashboard:
    image: nginx:alpine
    container_name: raven-dashboard
    restart: always
    volumes:
      - ./dashboard:/usr/share/nginx/html:ro
    ports:
      - "8080:80"

  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    restart: always
    ports:
      - "3000:3000"
    volumes:
      - ./grafana:/var/lib/grafana
EOF

# -----------------------------
# Prepare Dashboard
# -----------------------------
echo "[+] Creating placeholder dashboard"
mkdir -p dashboard
cat <<HTML > dashboard/index.html
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Raven0 Dashboard</title></head>
<body><h1>Raven0 Command & Control</h1><p>Status page coming soon.</p></body>
</html>
HTML

# -----------------------------
# Start Docker Services
# -----------------------------
echo "[+] Launching containers"
docker compose up -d

# -----------------------------
# Done
# -----------------------------
echo "[✓] Raven0 setup complete. Services are running on ports 80, 443, 3000, and 8080"
echo "[i] You must still configure a reverse proxy with Let's Encrypt, or deploy Caddy/nginx manually."
echo "[!] Remember to set correct Tailscale auth key and DNS for $DOMAIN before production use."
