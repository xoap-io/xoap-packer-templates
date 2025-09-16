#!/bin/bash
# Optimized removal of unused packages for Ubuntu 22.04

set -e

log() {
    echo "[PKGS] $1"
}

log "Removing orphaned packages..."
sudo apt-get autoremove --purge -y

log "Removing orphaned libraries (deborphan)..."
if ! command -v deborphan &>/dev/null; then
    sudo apt-get install -y deborphan
fi
for pkg in $(deborphan); do
    sudo apt-get -y remove --purge "$pkg"
done

log "Cleaning up residual config files..."
for pkg in $(dpkg -l | awk '/^rc/ {print $2}'); do
    sudo apt-get purge -y "$pkg"
done

log "Unused package removal complete."
