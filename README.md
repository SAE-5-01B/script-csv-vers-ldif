# script-csv-vers-ldif

Utilitaire permettant de passer d'un fichier csv à ldif afin d'automatiser le remplissage d'un annuaire LDAP.

## Utilisation

### Commande

```bash
./creerAnnuaire.sh -e domaine.env -c utilisateurs.csv
```

- **-e**: chemin vers le fichier contenant les informations sur le nom de domaine
- **-c**: chemin vers le fichier contenant les informations sur les utilisateurs

### Renseigner le nom de domaine

Il faut renseigner deux composant de domaine dans [`domaine.env`](./domaine.env) : 

```env
DOMAINENIV1=example
DOMAINENIV2=org
```

### Renseigner les informations sur les utilisateurs

Les informations sur les utilisateurs sont attendues dans un fichier au format [CSV](https://fr.wikipedia.org/wiki/Comma-separated_values) dont la première ligne est : 

```csv
Prenom,Nom,Datedenaissance,Groupe,EstAdmin
```

Par exmple, pour rensigner deux utilisateurs, on fera : 

```csv
Prenom,Nom,Datedenaissance,Groupe,EstAdmin
Mélanie,Zetofrais,03042000,G1,1
Judas,Nanas,12061999,G2,0
```

Concernant les attributs : 

- **Prenom**: chaîne de caractères quelconque, peut contenir des caractères spéciaux
- **Nom**: chaîne de caractères quelconque, peut contenir des caractères spéciaux
- **Datedenaissance**: au format jjmmaaa (ddmmyyyy)
- **Groupe**: chaîne de caractères quelconque, peut contenir des caractères spéciaux
- **EstAdmin**: 0 ou 1

Un exemple type de liste d'utilisateurs peut être retrouvé [ici](./utilisateurs.csv).
