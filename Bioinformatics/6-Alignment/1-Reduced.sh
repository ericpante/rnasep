#!/bin/bash

# Boucle sur chaque fichier .tab trouvé
for i in *.tab
do
    awk -F'\t' '{
  # Séparer la première colonne en utilisant '~~'
  split($1, arr, "~~");  # La partie avant '~~' dans arr[1], la partie après '~~' dans arr[2]
  
  # Supprimer la partie '.p1' ou '.p2' de la deuxième colonne (après '~~')
  sub(/\.p1$/, "", arr[2]);  # Enlève '.p1' de la deuxième partie
  sub(/\.p2$/, "", arr[2]);  # Enlève '.p2' de la deuxième partie
  # Mettre à jour la première colonne avec la partie modifiée après '~~'
  $1 = arr[2];
  
  # Imprimer la ligne entière avec la première colonne modifiée
  print $0;
}' OFS='\t' "${i}" > ${i%.tab}.tab.tmp
done

