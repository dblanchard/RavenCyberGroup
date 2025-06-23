#!/bin/bash
# setup.sh
# Initial provisioning script for remote raven devices (RPi)

set -euo pipefail

# -------------------------------
# Configuration Variables
# -------------------------------
TAILSCALE_AUTH_KEY="tskey-xxxxxxxxxxxxxxxx"   # Replace before deployment
HOSTNAME_PREFIX="raven"
DEVICE_ID=$(cat /proc/cpuinfo | grep Serial | awk '{print $3}' | tail -n 1)
HOSTNAME="$HOSTNAME_PREFIX-${DEVICE_ID: -4}"

# -------------------------------
# Host Hardening
# -------------------------------
echo "[+] Setting hostname to $HOSTNAME"
hostnamectl set-hostname "$HOSTNAME"

echo "[+] Disabling password SSH logins"
sed -i 's/^#*PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# -------------------------------
# System Updates
# -------------------------------
echo "[+] Updating system packages"
apt update && apt upgrade -y

# -------------------------------
# Install Dependencies
# -------------------------------
echo "[+] Installing dependencies"
apt install -y curl tailscale ntp ufw unattended-upgrades

# -------------------------------
# Enable Firewall
# -------------------------------
echo "[+] Configuring UFW firewall"
ufw allow OpenSSH
ufw --force enable

# -------------------------------
# Schedule Health Checks
# -------------------------------
echo "[+] Scheduling health check task"
mkdir -p /opt/raven/
cat << 'EOF' > /opt/raven/health-checks.sh
#!/bin/bash
# health-checks.sh
# Simple status ping and basic telemetry log

TS_STATUS=$(tailscale status)
DATE=$(date -Iseconds)
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)

JSON_LOG="{\n  \"timestamp\": \"$DATE\",\n  \"ip\": \"$IP\",\n  \"uptime\": \"$UPTIME\",\n  \"tailscale_status\": \"$TS_STATUS\"\n}"

echo -e "$JSON_LOG"
EOF

chmod +x /opt/raven/health-checks.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /opt/raven/health-checks.sh >> /var/log/raven-health.log 2>&1") | crontab -

# -------------------------------
# Run Tailscale Setup
# -------------------------------
echo "[+] Creating tailscale-setup.sh"
cat << 'EOF' > tailscale-setup.sh
#!/bin/bash
# tailscale-setup.sh

set -e

AUTH_KEY="$1"

if [[ -z "$AUTH_KEY" ]]; then
  echo "[!] No Tailscale auth key provided"
  exit 1
fi

systemctl enable --now tailscaled
sleep 2

tailscale up --authkey "$AUTH_KEY" --hostname "$HOSTNAME" --advertise-tags=tag:raven --ssh
EOF

chmod +x tailscale-setup.sh
bash tailscale-setup.sh "$TAILSCALE_AUTH_KEY"

# -------------------------------
# Done
# -------------------------------
echo "[+] Setup complete. Rebooting..."
reboot
