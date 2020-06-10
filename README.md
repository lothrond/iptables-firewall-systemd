# iptables-firewall-systemd
An iptables firewall for linux systems running systemd.

# What this does:

This repository contians a bash script, (to setup some more well-known iptables rules), and a systemd service file (to start/stop the service at boot, etc). Upon install, you will have a bash script: `/usr/sbin/iptables-firewall.sh` and also, a systemd service file: `/etc/systemd/system/iptables-firewall.service`. The service is set to automatically set rules at boot.

# Installation

To install:

    sudo make install

To remove:

    sudo make remove

# Systemd

Upon install, the service is set to automatically set rules at boot time with:

    systemctl start iptables-firewall.service

To stop rules from being set at boot time:

    systemctl disable iptables-firewall.service

To stop rules *now*:

    systemctl stop iptables-firewall.service

