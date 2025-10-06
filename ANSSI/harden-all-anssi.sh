#!/bin/bash

# ==============================================================================
# SCRIPT MAÎTRE DE DURCISSEMENT (HARDENING) ANSSI
# ==============================================================================

# Ce script exécute toutes les étapes de durcissement dans l'ordre :
# 1. Catégorie M (Minimal)
# 2. Catégorie I (Intermediaire / Intrusion)

# Chemins relatifs aux répertoires de scripts
M_DIR="./M"
I_DIR="./I"

# Vérification des privilèges root
if [[ "$EUID" -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root. Utilisez 'sudo ./harden-all-anssi.sh'"
    exit 1
fi

# ==============================================================================
# 1. Exécution des scripts de la catégorie M (Minimal)
# ==============================================================================
echo "################################################################"
echo "# DÉMARRAGE : EXÉCUTION DES SCRIPTS DE LA CATÉGORIE M (Minimal) #"
echo "################################################################"

# Liste ordonnée des scripts M : R30, R31, R53, R54, R56, R59, R61, R62, R68, R80
M_SCRIPTS=(
    "R30.sh" # Désactiver les comptes utilisateur inutilisés
    "R31.sh" # Utiliser des mots de passe robustes
    "R53.sh" # Éviter les fichiers ou répertoires sans utilisateur ou sans groupe connu
    "R54.sh" # Activer le sticky bit sur les répertoires inscriptibles
    "R56.sh" # Éviter l'usage d'exécutables avec les droits setuid/setgid
    "R59.sh" # Utiliser des dépôts de paquets de confiance
    "R61.sh" # Effectuer des mises à jour régulières (installe unattended-upgrades)
    "R62.sh" # Désactiver les services non nécessaires (supprime exim4)
    "R68.sh" # Protéger les mots de passe stockés (configure yescrypt)
    "R80.sh" # Réduire la surface d'attaque SSH (limite ListenAddress)
)

for script in "${M_SCRIPTS[@]}"; do
    echo -e "\n--- Exécution de ${M_DIR}/${script} ---"
    if [ -f "${M_DIR}/${script}" ]; then
        # Exécution simple pour les scripts M car ils n'ont pas de dépendances de chemin relatif de fichiers conf
        bash "${M_DIR}/${script}"
        if [ $? -ne 0 ]; then
            echo "ERREUR : Le script ${script} a échoué. Poursuite avec le script suivant."
        fi
    else
        echo "AVERTISSEMENT : Le script ${script} est introuvable."
    fi
done


# ==============================================================================
# 2. Exécution des scripts de la catégorie I (Intermediaire)
# ==============================================================================
echo -e "\n###################################################################"
echo "# DÉMARRAGE : EXÉCUTION DES SCRIPTS DE LA CATÉGORIE I (Intermediaire) #"
echo "###################################################################"

# Liste ordonnée des scripts I : R05, R08, R09, R11, R12, R13, R14, R32
I_SCRIPTS=(
    "R05.sh" # Configurer un mot de passe pour le chargeur de démarrage (GRUB)
    "R08.sh" # Paramétrer les options de configuration de la mémoire
    "R09.sh" # Paramétrer les options de configuration du noyau (utilise sysctl-kernel.conf)
    "R11.sh" # Activer et configurer le LSM Yama (utilise sysctl-yama.conf)
    "R12.sh" # Paramétrer les options de configuration du réseau (utilise sysctl-network.conf)
    "R13.sh" # Désactiver le plan IPv6 (utilise sysctl-ipv6.conf)
    "R14.sh" # Paramétrer les options de configuration des systèmes de fichiers (utilise sysctl-filesystem.conf)
    "R32.sh" # Expirer les sessions utilisateur locales
)

# Changer de répertoire de travail pour les scripts I afin d'assurer que les
# fichiers de configuration (sysctl-*.conf) sont trouvés grâce aux chemins relatifs.
cd "${I_DIR}" || { echo "ERREUR : Impossible d'accéder au répertoire ${I_DIR}. Arrêt du script." ; exit 1; }

for script in "${I_SCRIPTS[@]}"; do
    echo -e "\n--- Exécution de ${I_DIR}/${script} ---"
    if [ -f "${script}" ]; then
        bash "./${script}"
        if [ $? -ne 0 ]; then
            echo "ERREUR : Le script ${script} a échoué. Poursuite avec le script suivant."
        fi
    else
        echo "AVERTISSEMENT : Le script ${script} est introuvable."
    fi
done

# Retour au répertoire initial
cd ..

echo -e "\n#####################################################"
echo "# TERMINÉ : Toutes les étapes de durcissement ont été tentées. #"
echo "#####################################################"