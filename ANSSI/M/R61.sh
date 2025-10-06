#!/bin/bash

# R61 - Effectuer des mises à jour régulières
apt install unattended-upgrades apt-listchanges
dpkg-reconfigure --priority=low unattended-upgrades
