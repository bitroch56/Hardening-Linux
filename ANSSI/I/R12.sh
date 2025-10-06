# R12 - Paramétrer les options de configuration du réseau
echo "Étape R12: Paramétrer les options de configuration du réseau."
sleep 5
# Copie du fichier sysctl-network.conf recommandé par l'ANSSI
cp sysctl-network.conf /etc/sysctl.d/98-sysctl-network.conf
# Application des nouvelles configurations
sysctl -p /etc/sysctl.d/98-sysctl-network.conf