#!/bin/bash

# R05 - Configurer un mot de passe pour le chargeur de démarrage
apt install grub-common
grub-mkpasswd-pbkdf2 # générer mot de passe chiffré
update-grub