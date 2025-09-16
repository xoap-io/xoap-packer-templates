#!/bin/bash
# Optimized disabling of unnecessary services for Ubuntu 22.04

set -e

log() {
    echo "[SERVICE] $1"
}

# List of common unnecessary services for servers
SERVICES=(cups avahi-daemon bluetooth modemmanager rpcbind lxd snapd ufw)

for svc in "${SERVICES[@]}"; do
    if systemctl list-unit-files | grep -q "^$svc"; then
        log "Disabling and stopping $svc..."
        sudo systemctl disable $svc || true
        sudo systemctl stop $svc || true
        # Try to purge if it's a package
        if dpkg -l | grep -q "^ii  $svc"; then
            log "Purging package $svc..."
            sudo apt-get purge -y $svc || true
        fi
    else
        log "$svc not present, skipping."
    fi

done

log "Unneeded service disabling complete."
