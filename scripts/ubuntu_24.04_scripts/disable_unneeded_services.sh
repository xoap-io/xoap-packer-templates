#!/bin/bash
###############################################################################
# XOAP Image Management Script
# Disables unnecessary services on Ubuntu 24.04 (examples: cups, avahi-daemon, bluetooth).
#
# Developed and optimized for use with the XOAP Image Management module,
# but can be used independently.
# No liability is assumed for the function, use, or consequences of this
# freely available script.
# XOAP is a product of RIS AG. © RIS AG
###############################################################################

for svc in cups avahi-daemon bluetooth; do
  sudo systemctl disable $svc 2>/dev/null
  sudo systemctl stop $svc 2>/dev/null
done
