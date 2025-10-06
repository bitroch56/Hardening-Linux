#!/bin/bash

# R68 - Protéger les mots de passe stockés
echo "Étape R68: Protection des mots de passe stockés."
sleep 5
# Ajouter ~~~~password [success=1 default=ignore] pam_unix.so obscure yescrypt rounds=11 dans /etc/pam.d/common-password
if ! grep -q "pam_unix.so.*yescrypt" /etc/pam.d/common-password; then
    sed -i '/pam_unix.so/ s/$/ obscure yescrypt rounds=11/' /etc/pam.d/common-password
fi
# Vérifier yescrypt dans /etc/shadow ([username]:$y$j9T$xxxx:20342:0:99999:7:::) (grep de :$y:$)
if ! grep -q ":$y:" /etc/shadow; then
    echo "Il semble qu'un/e utilisateur n'utilise pas yescrypt pour le hachage des mots de passe."
    echo "Veuillez migrer les mots de passe vers yescrypt manuellement."
fi