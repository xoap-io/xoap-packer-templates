#!/bin/sh -eux
###############################################################################
# XOAP Image Management Script
# Cleans and minimizes Ubuntu 24.04 system for imaging.
#
# Developed and optimized for use with the XOAP Image Management module,
# but can be used independently.
# No liability is assumed for the function, use, or consequences of this
# freely available script.
# XOAP is a product of RIS AG. © RIS AG
###############################################################################

echo "Removing linux-headers packages..."
dpkg --list | awk '{ print $2 }' | grep '^linux-headers' | xargs -r apt-get -y purge

echo "Removing old Linux kernels (except current)..."
dpkg --list | awk '{ print $2 }' | grep '^linux-image-.*-generic' | grep -v "$(uname -r)" | xargs -r apt-get -y purge

echo "Removing old kernel modules packages (except current)..."
dpkg --list | awk '{ print $2 }' | grep '^linux-modules-.*-generic' | grep -v "$(uname -r)" | xargs -r apt-get -y purge

echo "Removing linux-source package..."
dpkg --list | awk '{ print $2 }' | grep '^linux-source' | xargs -r apt-get -y purge

echo "Removing all development packages..."
dpkg --list | awk '{ print $2 }' | grep -- '-dev\(:[a-z0-9]\+\)\?$' | xargs -r apt-get -y purge

echo "Removing documentation packages..."
dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs -r apt-get -y purge

echo "Removing X11 libraries..."
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6

echo "Removing obsolete networking packages..."
apt-get -y purge ppp pppconfig pppoeconf

echo "Removing unnecessary packages..."
apt-get -y purge popularity-contest command-not-found friendly-recovery bash-completion laptop-detect motd-news-config usbutils grub-legacy-ec2

echo "Removing fonts-ubuntu-font-family-console (if present)..."
apt-get -y purge fonts-ubuntu-font-family-console || true

echo "Removing installation-report and popularity-contest (if present)..."
apt-get -y purge installation-report popularity-contest || true

echo "Removing fonts-ubuntu-console (if present)..."
apt-get -y purge fonts-ubuntu-console || true

echo "Removing command-not-found-data (if present)..."
apt-get -y purge command-not-found-data || true

echo "Setting up dpkg excludes for linux-firmware..."
cat <<_EOF_ >> /etc/dpkg/dpkg.cfg.d/excludes
#BENTO-BEGIN
path-exclude=/lib/firmware/*
path-exclude=/usr/share/doc/linux-firmware/*
#BENTO-END
_EOF_

echo "Deleting massive firmware files..."
rm -rf /lib/firmware/*
rm -rf /usr/share/doc/linux-firmware/*

echo "Autoremoving packages and cleaning apt data..."
apt-get -y autoremove
apt-get -y clean

echo "Removing /usr/share/doc/* ..."
rm -rf /usr/share/doc/*

echo "Cleaning /var/cache ..."
find /var/cache -type f -exec rm -rf {} +

echo "Truncating logs in /var/log ..."
find /var/log -type f -exec truncate --size=0 {} +

echo "Blanking netplan machine-id (DUID) for unique ID on boot..."
truncate -s 0 /etc/machine-id
if [ -f /var/lib/dbus/machine-id ]; then
  truncate -s 0 /var/lib/dbus/machine-id
fi

echo "Removing contents of /tmp and /var/tmp ..."
rm -rf /tmp/* /var/tmp/*

echo "Forcing new random seed to be generated ..."
rm -f /var/lib/systemd/random-seed

echo "Clearing history ..."
rm -f /root/.wget-hsts
export HISTSIZE=0

echo "Cleanup complete."
