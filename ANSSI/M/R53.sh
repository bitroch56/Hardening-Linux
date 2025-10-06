#!/bin/bash

# R53 - Éviter les fichiers ou répertoires sans utilisateur ou sans groupe connu
echo "Étape R53: Suppression des fichiers ou répertoires sans utilisateur ou sans groupe connu."
sleep 5
# Trouver et supprimer les fichiers sans utilisateur ou groupe connu
find / -type f \( -nouser -o -nogroup \) -ls 2>/dev/null | awk '{print $3}' | xargs -r rm -f