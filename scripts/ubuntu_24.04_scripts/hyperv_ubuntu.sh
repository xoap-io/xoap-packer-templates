#!/bin/sh -eux

if [ "${PACKER_BUILDER_TYPE}" = "hyperv-iso" ]; then
    echo "Installing Hyper-V integration packages..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        linux-image-virtual \
        linux-tools-virtual \
        linux-cloud-tools-virtual
    echo "Hyper-V integration packages installed
