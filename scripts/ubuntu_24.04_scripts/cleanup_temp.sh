#!/usr/bin/env bash
###############################################################################
# XOAP Image Management Script
# Cleans apt cache and temporary files on Ubuntu 24.04.
#
# Developed and optimized for use with the XOAP Image Management module,
# but can be used independently.
# No liability is assumed for the function, use, or consequences of this
# freely available script.
# XOAP is a product of RIS AG. © RIS AG
###############################################################################

set -Eeuo pipefail
IFS=$'\n\t'

# Clean apt cache and temporary files
apt-get clean -y || true
rm -rf /tmp/* || true
rm -rf /var/tmp/* || true
