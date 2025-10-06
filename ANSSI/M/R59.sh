#!/bin/bash

# R59 - Utiliser des dépôts de paquets de confiance
echo "Étape R59: Configuration des dépôts de paquets de confiance."
sleep 5
# Sauvegarder le fichier sources.list existant
cp /etc/apt/sources.list /etc/apt/sources.list.bak
# Configurer les dépôts officiels (exemple pour Debian stable) avec commentaires
cat <<EOL >/etc/apt/sources.list
# Dépôts officiels Debian Stable
deb http://deb.debian.org/debian stable main contrib non-free
deb-src http://deb.debian.org/debian stable main contrib non-free
# Dépôts de sécurité
deb http://security.debian.org/debian-security stable-security main contrib non-free
deb-src http://security.debian.org/debian-security stable-security main contrib non-free
# Dépôts de mises à jour stables
deb http://deb.debian.org/debian stable-updates main contrib non-free
deb-src http://deb.debian.org/debian stable-updates main contrib non-free
EOL