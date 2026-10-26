# Schéma relationnel - Gargote de Rado

## Etape 1 : La carte

### Table plat

| Colonne | Type | Contraintes | Description |
|---|---|---|---|
| id_plat | SERIAL | PRIMARY KEY | id unique des plats |
| nom_plat | VARCHAR(100) | NOT NULL | nom du plat |
| prix | INTEGER | NOT NULL | prix du plat en ariary |

PLAT(**id_plat**, nom_plat, prix)

Réponse au piège :
Pour le prix j'ai pris INTEGER parce que les montants sont en ariary sans centimes, donc un entier suffit. Pour l'identifiant j'utilise id_plat en clé primaire, comme ça chaque plat est identifié de façon unique même si deux plats ont le même nom.

## Etape 2 : La catégorie

### CATEGORIE (nouveau)
- CATEGORIE(**id_categorie**, nom_categorie)
- id_categorie : SERIAL, clé primaire
- nom_categorie : VARCHAR(100), NOT NULL

### PLAT (modifié)
- PLAT(**id_plat**, nom_plat, prix, #id_categorie)
- id_plat : SERIAL, clé primaire
- nom_plat : VARCHAR(100), NOT NULL
- prix : INTEGER, NOT NULL
- id_categorie : INTEGER, clé étrangère vers CATEGORIE(id_categorie), NOT NULL

Réponse au piège :
Avec une simple colonne categorie VARCHAR(50) dans plat, rien n'empêche d'écrire "Boisson" pour un plat, "Boissons" pour un autre et "boisson" pour un troisième. Pour la base ça fait trois catégories différentes, donc un GROUP BY ou un WHERE donne des résultats faux. Si Rado veut renommer une catégorie il faut en plus modifier toutes les lignes de plat concernées, alors qu'avec une table categorie on change une seule ligne. Et une catégorie sans plat ne pourrait même pas exister.
