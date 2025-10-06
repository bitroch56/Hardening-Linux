#!/bin/bash

# R56 - Éviter l'usage d'exécutables avec les droits spéciaux setuid et setgid
echo "Étape R56: Vérification des exécutables avec setuid et setgid."
sleep 5
# Trouver les fichiers avec setuid ou setgid
find / -type f \( -perm -4000 -o -perm -2000 \) -ls 2>/dev/null
# Ajouter les fichiers trouvés au tableau des actions pour revue par l'admin
declare -A actions
actions["/bin/su"]="Vérifier nécessité du setuid/setgid"
for key in "${!actions[@]}"; do
    echo "$key|${actions[$key]}"
done > /tmp/actions.txt