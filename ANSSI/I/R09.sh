# R09 - Paramétrer les options de configuration du noyau
echo "Étape R09: Paramétrer les options de configuration du noyau."
sleep 5
# Copie du fichier sysctl-kernel.conf recommandé par l'ANSSI
cp sysctl-kernel.conf /etc/sysctl.d/96-sysctl-kernel.conf
# Application des nouvelles configurations
sysctl -p /etc/sysctl.d/96-sysctl-kernel.conf