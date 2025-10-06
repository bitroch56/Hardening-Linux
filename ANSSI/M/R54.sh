#!/bin/bash

# R54 Activer le sticky bit sur les répertoires inscriptibles
echo "Étape R54: Activation du sticky bit sur les répertoires inscriptibles."
sleep 5
# Trouver les répertoires inscriptibles par d'autres et activer le sticky
find / -type d -perm -0002 ! -perm -1000 -exec chmod +t {} \; 2>/dev/null