#!/bin/bash

# R62 - Désactiver les services non nécessaires
echo "Étape R62: Désactivation des services non nécessaires."
sleep 5
# Désactiver et supprimer Exim4 si installé
systemctl stop exim4
apt remove --purge exim4*
apt autoremove