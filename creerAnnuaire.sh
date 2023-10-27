#!/bin/bash

mkdir out

# purge de userData.ldif
> out/userData.ldif
> out/groupData.ldif

# Récupération des fichier précisés avec les arguments -env et -csv
while [ $# -gt 0 ]; do
  case "$1" in
    -env | -e)
      shift
      if [ -n "$1" ] && [ -f "$1" ]; then
        ENV="$(cat "$1")"
        export $ENV
      else
        echo "Fichier -env non spécifié ou introuvable."
        exit 1
      fi
      ;;
    -csv | -c)
      shift
      if [ -n "$1" ] && [ -f "$1" ]; then
        CSV="$(cat "$1")"

        # Vérifier si le fichier commence par la ligne attendue
        expected_header="Prenom,Nom,Datedenaissance,Groupe,EstAdmin"
        if ! head -n 1 "$1" | grep -q "$expected_header"; then
          echo "Le fichier -csv ne commence pas par la ligne attendue."
          exit 1
        fi

      else
        echo "Fichier -csv non spécifié ou introuvable."
        exit 1
      fi
      ;;
    *)
      echo "Paramètre non reconnu: $1"
      exit 1
      ;;
  esac
  shift
done

IFS=$'\n'  # Définir le séparateur de ligne pour éviter les problèmes d'espaces
for line in $(echo "$CSV" | tail -n +2); do

  IFS=','  # Rétablir le séparateur de champ par défaut
  read -ra fields <<< "$line"
            
  # Accéder aux valeurs individuelles
  export prenom="${fields[0]}"
  export nom="${fields[1]}"
  export datenaissance="${fields[2]}"
  export groupe="${fields[3]}"
  export estadmin="${fields[4]}"
  export uid="$(echo ${prenom:0:1}${nom} | tr '[:upper:]' '[:lower:]'| iconv -f UTF-8 -t ASCII//TRANSLIT | sed -e 's/[^a-zA-Z0-9]//g')"
  export mdp="$(echo ${prenom:0:1}${nom:0:1}${datenaissance} | tr '[:upper:]' '[:lower:]'| iconv -f UTF-8 -t ASCII//TRANSLIT | sed -e 's/[^a-zA-Z0-9]//g')"

  envsubst < ./templates/userData.ldif.template >> out/userData.ldif

  if ! grep -q "cn: $groupe" out/groupData.ldif; then
    envsubst < ./templates/groupData.ldif.template >> out/groupData.ldif
  fi

  envsubst < ./templates/memberData.ldif.template > out/memberData.ldif
  sed -i "/cn: $groupe/r out/memberData.ldif" out/groupData.ldif

done

export GROUPES=$(cat out/groupData.ldif)
export UTILISATEURS=$(cat out/userData.ldif)

envsubst < ./templates/ldap.ldif.template > out/ldap.ldif

rm out/memberData.ldif
