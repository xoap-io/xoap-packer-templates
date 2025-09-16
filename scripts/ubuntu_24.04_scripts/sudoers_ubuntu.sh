#!/bin/sh -eux

# Add exempt_group=sudo after Defaults env_reset for sudoers
sed -i -e '/^Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers

# Set up password-less sudo for the vagrant user
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99_vagrant
chmod 0440 /etc/sudoers.d/99_vagrant

# Validate sudoers files
visudo -cf /etc/sudoers
visudo -cf /etc/sudoers.d/99_vagrant

echo "Sudoers configuration
