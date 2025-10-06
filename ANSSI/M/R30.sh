#!/bin/bash

# R30 - Désactiver les comptes utilisateur inutilisés
echo "Étape R30: Désactivation des comptes utilisateur inutilisés."
sleep 5
sudo usermod -L news
sudo usermod -L uucp
sudo usermod -L games
sudo usermod -L irc
sudo usermod -L nobody
sudo usermod -L list
sudo usermod -L www-data
sudo usermod -L Debian-exim
