#!/bin/sh -eux

# Get Ubuntu major version
ubuntu_version="$(lsb_release -r | awk '{print $2}')"
major_version="$(echo "$ubuntu_version" | awk -F. '{print $1}')"

if [ "$major_version" -ge "18" ]; then
    echo "Creating netplan config for eth0..."
    cat <<EOF >/etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
EOF
else
    # Add a 2 sec delay to the interface up, to make dhclient happy
    echo "pre-up sleep 2" >> /etc/network/interfaces
fi

# Disable Predictable Network Interface names and use eth0
if [ -e /etc/network/interfaces ]; then
    sed -i 's/en[[:alnum:]]*/eth0/g' /etc/network/interfaces
fi

sed -i 's/GRUB_CMDLINE_LINUX="\([^"]*\)"/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 \1"/g' /etc/default/grub
update-grub

echo "Networking configuration updated
