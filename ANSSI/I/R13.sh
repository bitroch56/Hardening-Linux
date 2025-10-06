# R13 - Désactiver le plan IPv6
echo "Étape R13: Désactiver le plan IPv6."
sleep 5
# Copie du fichier sysctl-ipv6.conf recommandé par l'ANSSI
cp sysctl-ipv6.conf /etc/sysctl.d/99-sysctl-ipv6.conf
# Application des nouvelles configurations
sysctl -p /etc/sysctl.d/99-sysctl-ipv6.conf
# Désactivation d'IPv6 au démarrage
if ! grep -q "ipv6.disable=1" /etc/default/grub; then
    echo "Désactivation d'IPv6 au démarrage."
    sed -i 's/GRUB_CMDLINE_LINUX="\(.*\)"/
    GRUB_CMDLINE_LINUX="\1 ipv6.disable=1"/' /etc/default/grub
    update-grub
else
    echo "IPv6 est déjà désactivé au démarrage."
fi
