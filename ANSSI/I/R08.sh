# R08 - Paramétrer les options de configuration de la mémoire
echo "Étape R08: Paramétrer les options de configuration de la mémoire."
sleep 5
# Modifier /etc/default/grub pour ajouter les options suivantes à la ligne GRUB_CMDLINE_LINUX_DEFAULT
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="page_poison=on pti=on slab_nomerge=yes slub_debug=FZP spectre_v2=on spec_store_bypass_disable=seccomp mds=full,nosmt mce=0 page_alloc.shuffle=1 rng_core.default_quality=500 /' /etc/default/grub
# Mettre à jour GRUB
update-grub
