#!/bin/bash

# Nom du fichier de configuration SSH
CONFIG_FILE="/etc/ssh/sshd_config"
# Adresse IP à laquelle limiter l'écoute SSH (remplacez par l'IP de votre VM si elle est différente)
LISTEN_IP="10.0.2.15"

# Vérifie si le script est exécuté en tant que root (nécessaire pour modifier le fichier et redémarrer le service)
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté avec les privilèges root (sudo)."
    exit 1
fi

echo "Début de la réduction de la surface d'attaque SSH..."

# 1. Sauvegarder la configuration actuelle avant toute modification
echo "Sauvegarde de la configuration actuelle dans ${CONFIG_FILE}.bak"
cp "${CONFIG_FILE}" "${CONFIG_FILE}.bak"

# 2. Modifier les directives ListenAddress et AddressFamily

# a) Mettre à jour ou ajouter la directive AddressFamily pour n'utiliser qu'IPv4
if grep -q "^#AddressFamily" "$CONFIG_FILE" || grep -q "^AddressFamily" "$CONFIG_FILE"; then
    # Décommenter et/ou remplacer une directive AddressFamily existante
    sed -i '/^#\?AddressFamily/c\AddressFamily inet' "$CONFIG_FILE"
else
    # Ajouter la directive AddressFamily si elle n'existe pas
    echo "AddressFamily inet" >> "$CONFIG_FILE"
fi

# b) Mettre à jour ou ajouter la directive ListenAddress
# Pour éviter la duplication, nous allons d'abord supprimer toute occurrence de ListenAddress, puis l'ajouter.
sed -i '/^#\?ListenAddress/d' "$CONFIG_FILE"

# Ajouter la directive ListenAddress pour l'IP spécifique
echo "ListenAddress ${LISTEN_IP}" >> "$CONFIG_FILE"
echo "Configuration mise à jour : Écoute limitée à l'adresse ${LISTEN_IP} et AddressFamily réglée sur inet."

# 3. Redémarrer le service SSH
echo "Redémarrage du service SSH pour appliquer les changements..."

# Attention : Le redémarrage peut couper votre connexion si l'adresse IP spécifiée n'est pas correcte
# ou si vous avez des règles de pare-feu restrictives.
systemctl restart ssh

if [ $? -eq 0 ]; then
    echo "Service SSH redémarré avec succès."
    
    # 4. Vérification (Optionnel)
    echo -e "\nÉtat actuel des services en écoute (ss -tulpen | grep :22):"
    ss -tulpen | grep :22
    
    if ss -tulpen | grep -q "${LISTEN_IP}:22"; then
        echo -e "\n✅ Vérification réussie : SSH écoute maintenant sur ${LISTEN_IP}:22."
        echo "La surface d'attaque du service SSH a été réduite."
    else
        echo -e "\n❌ ATTENTION : La vérification n'a pas montré ${LISTEN_IP}:22. Le service pourrait ne pas avoir démarré correctement."
    fi
else
    echo -e "\n❌ ERREUR : Le redémarrage du service SSH a échoué. Veuillez vérifier les logs."
    # Rétablir la configuration précédente pour éviter de rester bloqué (si possible)
    cp "${CONFIG_FILE}.bak" "${CONFIG_FILE}"
    echo "La configuration SSH précédente a été restaurée à partir de ${CONFIG_FILE}.bak."
fi