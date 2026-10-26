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


## Etape 4 : Les habitués

### Schéma complet
- CATEGORIE(**id_categorie**, nom_categorie)
- PLAT(**id_plat**, nom_plat, prix, #id_categorie)
- CLIENT(**id_client**, nom_client, telephone?) (nouveau)
- COMMANDE(**id_commande**, date_commande, #id_client?) (modifié)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite)

### CLIENT (nouveau)
- id_client : SERIAL, clé primaire
- nom_client : VARCHAR(100), NOT NULL
- telephone : VARCHAR(20), facultatif

### COMMANDE (modifié)
- id_client : INTEGER, clé étrangère vers CLIENT(id_client), facultative

Réponse au piège :
Non, la clé étrangère id_client n'est pas NOT NULL, parce que la plupart des clients sont de passage et Rado ne leur demande rien. Pour ne perdre aucune commande il faut un LEFT JOIN en partant de commande : avec un JOIN simple, toutes les commandes sans client disparaissent du résultat.


## Etape 5 : Serveurs et tables

### Schéma complet
- CATEGORIE(**id_categorie**, nom_categorie)
- PLAT(**id_plat**, nom_plat, prix, #id_categorie)
- CLIENT(**id_client**, nom_client, telephone?)
- SERVEUR(**id_serveur**, nom_serveur) (nouveau)
- TABLE_SALLE(**id_table**, numero) (nouveau)
- COMMANDE(**id_commande**, date_commande, #id_client?, #id_serveur, #id_table?) (modifié)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite)

### SERVEUR (nouveau)
- id_serveur : SERIAL, clé primaire
- nom_serveur : VARCHAR(100), NOT NULL

### TABLE_SALLE (nouveau)
- id_table : SERIAL, clé primaire
- numero : INTEGER, NOT NULL, UNIQUE

### COMMANDE (modifié)
- id_serveur : INTEGER, clé étrangère vers SERVEUR(id_serveur), NOT NULL
- id_table : INTEGER, clé étrangère vers TABLE_SALLE(id_table), facultative (NULL pour les plats à emporter)

Réponse au piège :
Une table de la salle et une commande n'ont rien à voir : la table existe toute seule, même sans commande, et elle sert plusieurs fois dans la journée, alors qu'une commande est un événement avec une date, un serveur et des plats. Une commande a au plus une table (aucune quand c'est à emporter), donc id_table est une clé étrangère facultative dans commande. Le mot table pose problème parce que c'est un mot réservé du SQL (CREATE TABLE, ALTER TABLE), donc j'ai appelé la mienne table_salle.


## Etape 6 : Les paiements

### Schéma complet
- CATEGORIE(**id_categorie**, nom_categorie)
- PLAT(**id_plat**, nom_plat, prix, #id_categorie)
- CLIENT(**id_client**, nom_client, telephone?)
- SERVEUR(**id_serveur**, nom_serveur)
- TABLE_SALLE(**id_table**, numero)
- COMMANDE(**id_commande**, date_commande, #id_client?, #id_serveur, #id_table?)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite)
- MODE_PAIEMENT(**id_mode**, libelle) (nouveau)
- PAIEMENT(**id_paiement**, #id_commande, #id_mode, montant, reference_transaction?, date_paiement) (nouveau)

### MODE_PAIEMENT (nouveau)
- id_mode : SERIAL, clé primaire
- libelle : VARCHAR(50), NOT NULL, UNIQUE

### PAIEMENT (nouveau)
- id_paiement : SERIAL, clé primaire
- id_commande : INTEGER, clé étrangère vers COMMANDE(id_commande), NOT NULL
- id_mode : INTEGER, clé étrangère vers MODE_PAIEMENT(id_mode), NOT NULL
- montant : INTEGER, NOT NULL, strictement positif
- reference_transaction : VARCHAR(50), facultative (seulement pour le mobile money)
- date_paiement : DATE, NOT NULL, par défaut la date du jour

Réponse au piège :
Une colonne montant_paye dans commande ne suffit pas parce qu'une commande peut être payée en plusieurs fois et par plusieurs moyens : on perdrait le détail (10 000 en espèces et 5 000 en MVola), les références des transactions et les dates, et il faudrait la mettre à jour à la main à chaque paiement. Pour le mode de paiement j'ai choisi une table de référence plutôt qu'un CHECK. Le CHECK est plus rapide à écrire et suffit si la liste ne change jamais, mais dès que Rado accepte un nouvel opérateur il faut modifier la contrainte, alors qu'avec la table un simple INSERT suffit. En contrepartie il y a une jointure de plus à faire.


## Etape 7 : Les prix changent

### Schéma complet
- CATEGORIE(**id_categorie**, nom_categorie)
- PLAT(**id_plat**, nom_plat, prix, #id_categorie)
- CLIENT(**id_client**, nom_client, telephone?)
- SERVEUR(**id_serveur**, nom_serveur)
- TABLE_SALLE(**id_table**, numero)
- COMMANDE(**id_commande**, date_commande, #id_client?, #id_serveur, #id_table?)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite, prix_unitaire) (modifié)
- MODE_PAIEMENT(**id_mode**, libelle)
- PAIEMENT(**id_paiement**, #id_commande, #id_mode, montant, reference_transaction?, date_paiement)
- HISTORIQUE_PRIX(**#id_plat**, **date_debut**, prix) (nouveau)

### LIGNE_COMMANDE (modifié)
- prix_unitaire : INTEGER, NOT NULL, prix du plat au moment de la commande

### HISTORIQUE_PRIX (nouveau)
- clé primaire composée (id_plat, date_debut)
- id_plat : INTEGER, clé étrangère vers PLAT(id_plat)
- date_debut : DATE, date à partir de laquelle le prix s'applique
- prix : INTEGER, NOT NULL, strictement positif

### PLAT
- la colonne prix reste le prix actuel de la carte

Réponse au piège :
En relançant la requête de l'étape 3 après l'augmentation, la commande 1 passe de 15 000 à 16 000 Ar alors que le client a déjà payé 15 000 : le montant lit le prix actuel dans plat, donc une ancienne facture change toute seule. J'ai ajouté prix_unitaire dans ligne_commande pour garder le prix au moment de la commande (recopié depuis plat pour les lignes existantes avant d'augmenter), et tous les montants se calculent maintenant avec ce prix. Pour le bonus, la table historique_prix garde chaque prix de chaque plat avec sa date de début.


## Etape 8 : Les ingrédients

### Schéma complet
- CATEGORIE(**id_categorie**, nom_categorie)
- PLAT(**id_plat**, nom_plat, prix, #id_categorie)
- CLIENT(**id_client**, nom_client, telephone?)
- SERVEUR(**id_serveur**, nom_serveur)
- TABLE_SALLE(**id_table**, numero)
- COMMANDE(**id_commande**, date_commande, #id_client?, #id_serveur, #id_table?)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite, prix_unitaire)
- MODE_PAIEMENT(**id_mode**, libelle)
- PAIEMENT(**id_paiement**, #id_commande, #id_mode, montant, reference_transaction?, date_paiement)
- HISTORIQUE_PRIX(**#id_plat**, **date_debut**, prix)
- INGREDIENT(**id_ingredient**, nom_ingredient, unite, stock) (nouveau)
- COMPOSITION_PLAT(**#id_plat**, **#id_ingredient**, quantite) (nouveau)

### INGREDIENT (nouveau)
- id_ingredient : SERIAL, clé primaire
- nom_ingredient : VARCHAR(100), NOT NULL, UNIQUE
- unite : VARCHAR(10), NOT NULL (g, ml)
- stock : INTEGER, NOT NULL, par défaut 0, jamais négatif

### COMPOSITION_PLAT (nouveau)
- clé primaire composée (id_plat, id_ingredient)
- id_plat : INTEGER, clé étrangère vers PLAT(id_plat)
- id_ingredient : INTEGER, clé étrangère vers INGREDIENT(id_ingredient)
- quantite : INTEGER, NOT NULL, strictement positive, exprimée dans l'unité de l'ingrédient pour une portion

Réponse au piège :
Une colonne ingredients VARCHAR(500) avec « riz, zébu, brèdes » n'est pas conseillée parce qu'on ne peut pas y stocker la quantité de chaque ingrédient, ni la relier au stock, ni faire une requête du genre « quels plats utilisent du riz ». En plus rien ne vérifie l'orthographe, "zébu" et "zebu" deviendraient deux ingrédients, et une case qui contient plusieurs valeurs casse la première forme normale.


## Etape 9 : Les menus du jour

### Schéma complet
- CATEGORIE(**id_categorie**, nom_categorie)
- PLAT(**id_plat**, nom_plat, prix, est_menu, #id_categorie) (modifié)
- CLIENT(**id_client**, nom_client, telephone?)
- SERVEUR(**id_serveur**, nom_serveur)
- TABLE_SALLE(**id_table**, numero)
- COMMANDE(**id_commande**, date_commande, #id_client?, #id_serveur, #id_table?)
- LIGNE_COMMANDE(**#id_commande**, **#id_plat**, quantite, prix_unitaire)
- MODE_PAIEMENT(**id_mode**, libelle)
- PAIEMENT(**id_paiement**, #id_commande, #id_mode, montant, reference_transaction?, date_paiement)
- HISTORIQUE_PRIX(**#id_plat**, **date_debut**, prix)
- INGREDIENT(**id_ingredient**, nom_ingredient, unite, stock)
- COMPOSITION_PLAT(**#id_plat**, **#id_ingredient**, quantite)
- COMPOSITION_MENU(**#id_menu**, **#id_plat**, quantite) (nouveau)

### CATEGORIE
- nouvelle ligne de données : Menus

### PLAT (modifié)
- est_menu : BOOLEAN, NOT NULL, par défaut FALSE

### COMPOSITION_MENU (nouveau)
- clé primaire composée (id_menu, id_plat)
- id_menu : INTEGER, clé étrangère vers PLAT(id_plat), le plat qui est un menu
- id_plat : INTEGER, clé étrangère vers PLAT(id_plat), un plat contenu dans le menu
- quantite : INTEGER, NOT NULL, par défaut 1, strictement positive
- contrainte CHECK (id_menu <> id_plat)

Réponse au piège :
Je n'ai pas fait de table menu séparée parce que le menu se commande exactement comme un plat : il a un nom, un prix, une catégorie et il apparaît dans ligne_commande. Avec deux tables il aurait fallu deux clés étrangères dans ligne_commande, ou dupliquer toute la logique des commandes. J'ai donc une association réflexive sur plat avec composition_menu. Pour empêcher un menu de se contenir lui-même j'ai mis un CHECK (id_menu <> id_plat). Il ne bloque que le cas direct : deux menus qui se contiennent l'un l'autre demanderaient un trigger ou un contrôle dans l'application.
