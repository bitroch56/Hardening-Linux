#!/bin/bash

# R31 - Utiliser des mots de passe robustes
echo "Étape R31: Mise en place de mots de passe robustes."
echo "Veuillez modifier votre mot de passe pour avoir 15 caractères, incluant des majuscules, minuscules, chiffres et caractères spéciaux."
# Entrée de texte avec vérification + double confirmation

# Vérifier qu'on est root
if [[ "$EUID" -ne 0 ]]; then
	echo "Ce script doit être exécuté en root pour modifier les mots de passe. Relancez avec sudo." >&2
	exit 1
fi

# Déterminer l'utilisateur courant (celui qui a lancé sudo) sinon $USER
CURRENT_USER="${SUDO_USER:-${USER:-}}"

# Construire la liste des comptes ciblés: root + user courant (si non vide)
TARGET_USERS=(root)
if [[ -n "$CURRENT_USER" && "$CURRENT_USER" != "root" ]]; then
	TARGET_USERS+=("$CURRENT_USER")
fi

is_strong_password() {
	local pw="$1"
	# Règles: longueur >= 15, au moins 1 minuscule, 1 majuscule, 1 chiffre, 1 spécial, pas d'espace
	[[ ${#pw} -ge 15 ]] || return 1
	[[ "$pw" =~ [a-z] ]] || return 1
	[[ "$pw" =~ [A-Z] ]] || return 1
	[[ "$pw" =~ [0-9] ]] || return 1
	[[ "$pw" =~ [^[:alnum:]] ]] || return 1
	[[ "$pw" =~ [[:space:]] ]] && return 1
	return 0
}

MAX_TRIES=3

for user in "${TARGET_USERS[@]}"; do
	tries=0
	echo "--> Configuration du mot de passe pour: $user"
	while (( tries < MAX_TRIES )); do
		((tries++))
		# Lecture masquée
		read -s -p "Nouveau mot de passe pour '$user' : " pw
		echo
		read -s -p "Confirmer le mot de passe : " pw2
		echo

		if [[ "$pw" != "$pw2" ]]; then
			echo "Les mots de passe ne correspondent pas. Tentative $tries / $MAX_TRIES."
			unset pw pw2
			continue
		fi

		if ! is_strong_password "$pw"; then
			cat <<EOF
Mot de passe rejeté : il doit respecter au moins :
 - longueur >= 15
 - au moins une minuscule
 - au moins une majuscule
 - au moins un chiffre
 - au moins un caractère spécial (ex: !@#$%&*)
 - pas d'espaces
Tentative $tries / $MAX_TRIES.
EOF
			unset pw pw2
			continue
		fi

		# Appliquer le mot de passe
		if command -v chpasswd >/dev/null 2>&1; then
			# appliquer via chpasswd (lit de stdin)
			printf '%s:%s\n' "$user" "$pw" | chpasswd
			echo "Mot de passe mis à jour pour '$user'."
			# Option: forcer le changement au prochain login si on le souhaite
			# chage -d 0 "$user"  # décommentez si nécessaire
		else
			echo "Avertissement : 'chpasswd' introuvable. Veuillez exécuter 'passwd $user' manuellement pour définir le mot de passe." >&2
			unset pw pw2
			break
		fi

		# Effacer les variables sensibles
		unset pw pw2
		break
	done

	if (( tries >= MAX_TRIES )); then
		echo "Échec : nombre maximum d'essais atteint pour l'utilisateur '$user'. Aucun changement effectué pour ce compte." >&2
	fi
done