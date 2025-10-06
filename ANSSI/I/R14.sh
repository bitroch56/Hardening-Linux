# R14 - Paramétrer les options de configuration des systèmes de fichiers
echo "Étape R14: Paramétrer les options de configuration des systèmes de fichiers."
sleep 5
# Copie du fichier sysctl-filesystem.conf recommandé par l'ANSSI
cp sysctl-filesystem.conf /etc/sysctl.d/96-sysctl-filesystem.conf
# Application des nouvelles configurations
sysctl -p /etc/sysctl.d/96-sysctl-filesystem.conf