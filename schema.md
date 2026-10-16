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