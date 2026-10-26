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


## Etape 3 : Les commandes

### Schéma complet
- CATEGORIE(**id_categorie**, nom_categorie)
- PLAT(**id_plat**, nom_plat, prix, #id_categorie)
- COMMANDE(**id_commande**, date_commande) (nouveau)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite) (nouveau)

### COMMANDE (nouveau)
- id_commande : SERIAL, clé primaire
- date_commande : DATE, NOT NULL, par défaut la date du jour

### LIGNE_COMMANDE (nouveau)
- clé primaire composée (id_commande, id_plat)
- id_commande : INTEGER, clé étrangère vers COMMANDE(id_commande)
- id_plat : INTEGER, clé étrangère vers PLAT(id_plat)
- quantite : INTEGER, NOT NULL, strictement positive

Réponse au piège :
J'ai mis la quantité dans ligne_commande, pas dans plat ni dans commande. Elle dépend à la fois de la commande et du plat (2 romazava dans une commande, 1 dans une autre), donc elle ne peut vivre que dans la table qui relie les deux. La clé composée (id_commande, id_plat) évite aussi de saisir deux fois le même plat dans une commande.
