SELECT 'Etape 1 : plats du plus cher au moins cher' AS verification;
SELECT current_database();
SELECT * FROM plat ORDER BY prix DESC;

SELECT 'Etape 2 : plats avec leur categorie' AS verification;
SELECT p.id_plat, p.nom_plat, p.prix, c.nom_categorie
FROM plat p
JOIN categorie c ON p.id_categorie = c.id_categorie
ORDER BY p.id_plat;

SELECT 'Etape 2 : nombre de plats par categorie' AS verification;
SELECT c.nom_categorie, COUNT(p.id_plat) AS nombre_plats
FROM categorie c
LEFT JOIN plat p ON c.id_categorie = p.id_categorie
GROUP BY c.id_categorie, c.nom_categorie
ORDER BY c.id_categorie;

SELECT 'Etape 3 : montant total de chaque commande' AS verification;
SELECT c.id_commande,
       c.date_commande,
       SUM(lc.quantite * p.prix) AS montant_total
FROM commande c
JOIN ligne_commande lc ON lc.id_commande = c.id_commande
JOIN plat p ON p.id_plat = lc.id_plat
GROUP BY c.id_commande, c.date_commande
ORDER BY c.id_commande;

SELECT 'Etape 4 : commandes avec le nom du client' AS verification;
SELECT c.id_commande,
       c.date_commande,
       COALESCE(cl.nom_client, 'client de passage') AS client
FROM commande c
LEFT JOIN client cl ON cl.id_client = c.id_client
ORDER BY c.id_commande;

SELECT 'Etape 5 : commandes et chiffre d affaires par serveur' AS verification;
SELECT s.nom_serveur,
       COUNT(DISTINCT c.id_commande) AS nombre_commandes,
       COALESCE(SUM(lc.quantite * p.prix), 0) AS chiffre_affaires
FROM serveur s
LEFT JOIN commande c ON c.id_serveur = s.id_serveur
LEFT JOIN ligne_commande lc ON lc.id_commande = c.id_commande
LEFT JOIN plat p ON p.id_plat = lc.id_plat
GROUP BY s.id_serveur, s.nom_serveur
ORDER BY s.id_serveur;
