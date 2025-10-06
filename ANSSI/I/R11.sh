# R11 : Activer et configurer le LSM Yama
echo "Étape R11: Activer et configurer le LSM Yama."
sleep 5
# Vérification de la présence de Yama
if ! grep -q "yama" /etc/lsm; then
    echo "Yama n'est pas activé. Activation de Yama."
    echo "yama" >> /etc/lsm
else
    echo "Yama est déjà activé."
fi
# Configuration de Yama
echo "Configurer Yama pour restreindre les ptrace."
# Copie du fichier de configuration recommandé par l'ANSSI
cp sysctl-yama.conf /etc/sysctl.d/97-sysctl-yama.conf
# Application des nouvelles configurations
sysctl -p /etc/sysctl.d/97-sysctl-yama.conf
