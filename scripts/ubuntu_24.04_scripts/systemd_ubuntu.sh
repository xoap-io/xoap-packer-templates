#!/bin/sh -eux

# Purpose: Ensure libpam-systemd is installed for proper systemd session management.
# Reference: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751636

echo "Updating package lists..."
apt-get update -y

echo "Installing libpam-systemd..."
DEBIAN_FRONTEND=noninteractive apt-get install -y libpam-systemd

echo "libpam
