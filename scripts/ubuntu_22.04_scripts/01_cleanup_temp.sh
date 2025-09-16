#!/bin/bash
# Optimized cleanup of apt cache and temporary files for Ubuntu 22.04

set -e

log() {
    echo "[CLEANUP] $1"
}

log "Cleaning apt cache..."
sudo apt-get clean

log "Removing temporary files..."
sudo rm -rf /tmp/* /var/tmp/* /var/cache/apt/archives/* /var/cache/apt/*.bin

log "Removing user cache and thumbnails..."
sudo rm -rf /home/*/.cache/* /home/*/.thumbnails/*

log "Removing systemd journal logs..."
sudo journalctl --rotate
sudo journalctl --vacuum-time=1d

log "Cleanup complete."
