# R32 - Expirer les sessions utilisateur locales
echo "Étape R32: Expirer les sessions utilisateur locales."
sleep 5
# Configuration de l'expiration des sessions
# Créer un fichier timeout.sh dans /etc/profile.d/ pour définir TMOUT
echo "#!/bin/bash" > /etc/profile.d/timeout.sh
echo "# Expire les sessions inactives après 900 secondes (15 minutes)" >> /etc/profile.d/timeout.sh
echo "TMOUT=900" >> /etc/profile.d/timeout.sh
echo "export TMOUT" >> /etc/profile.d/timeout.sh