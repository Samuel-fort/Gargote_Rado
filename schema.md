# Schéma relationnel - Gargote de Rado

## Etape 1 : La carte 

### Table 'plat'

Colonne     Type     Contraintes    Description
'id_plat'     SERIAL   PRIMARY_KEY    id unique des plats   
'nom_plat'    VARCHAR  NOT NULL      nom du plat 
'prix'        INTEGER  NOT NULL      Prix du plat en ariary

PLAT(**id_plat**,nom,prix)

Réponse piège:
 Type prix : INTEGER parce que le prix est un entier
 Identifiant : On utilise 'id_plat' comme PRIMARY_KEY pour identifier chaque plat de manière unique

## Etape 2 : La catégorie

### CATEGORIE (nouveau)
- (**id_categorie**, nom_categorie)
- id_categorie : SERIAL, clé primaire
- nom_categorie : VARCHAR(50), NOT NULL, UNIQUE

### PLAT (modifié)
- (**id_plat**, nom_plat, prix, #id_categorie)
- id_plat : SERIAL, clé primaire
- nom_plat : VARCHAR(100), NOT NULL
- prix : INTEGER, NOT NULL
- id_categorie : INTEGER, clé étrangère vers CATEGORIE(id_categorie), NOT NULL



Créer une table categorie évite de répéter les noms des catégories dans chaque plat et limite les erreurs d'écriture

