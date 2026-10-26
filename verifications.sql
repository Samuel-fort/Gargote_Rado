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
       SUM(lc.quantite * lc.prix_unitaire) AS montant_total
FROM commande c
JOIN ligne_commande lc ON lc.id_commande = c.id_commande
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
       COALESCE(SUM(lc.quantite * lc.prix_unitaire), 0) AS chiffre_affaires
FROM serveur s
LEFT JOIN commande c ON c.id_serveur = s.id_serveur
LEFT JOIN ligne_commande lc ON lc.id_commande = c.id_commande
GROUP BY s.id_serveur, s.nom_serveur
ORDER BY s.id_serveur;

SELECT 'Etape 6 : commandes non soldees' AS verification;
SELECT c.id_commande,
       t.montant_du,
       COALESCE(pa.montant_paye, 0) AS montant_paye,
       t.montant_du - COALESCE(pa.montant_paye, 0) AS reste_a_payer
FROM commande c
JOIN (SELECT id_commande, SUM(quantite * prix_unitaire) AS montant_du
      FROM ligne_commande
      GROUP BY id_commande) t ON t.id_commande = c.id_commande
LEFT JOIN (SELECT id_commande, SUM(montant) AS montant_paye
           FROM paiement
           GROUP BY id_commande) pa ON pa.id_commande = c.id_commande
WHERE t.montant_du > COALESCE(pa.montant_paye, 0)
ORDER BY c.id_commande;

SELECT 'Etape 7 : historique des prix du romazava' AS verification;
SELECT p.nom_plat, h.date_debut, h.prix
FROM historique_prix h
JOIN plat p ON p.id_plat = h.id_plat
WHERE h.id_plat = 1
ORDER BY h.date_debut;

SELECT 'Etape 7 : prix de la carte a une date donnee (12 octobre)' AS verification;
SELECT p.nom_plat, h.prix
FROM plat p
JOIN historique_prix h ON h.id_plat = p.id_plat
WHERE h.date_debut = (SELECT MAX(h2.date_debut)
                      FROM historique_prix h2
                      WHERE h2.id_plat = p.id_plat
                        AND h2.date_debut <= DATE '2026-10-12')
ORDER BY p.id_plat;

SELECT 'Etape 8 : consommation theorique du 12 octobre' AS verification;
SELECT i.nom_ingredient,
       i.unite,
       SUM(lc.quantite * cp.quantite) AS consommation
FROM commande c
JOIN ligne_commande lc ON lc.id_commande = c.id_commande
JOIN composition_plat cp ON cp.id_plat = lc.id_plat
JOIN ingredient i ON i.id_ingredient = cp.id_ingredient
WHERE c.date_commande = DATE '2026-10-12'
GROUP BY i.id_ingredient, i.nom_ingredient, i.unite
ORDER BY i.nom_ingredient;

SELECT 'Etape 9 : menus, prix a la carte et economie' AS verification;
SELECT m.nom_plat AS menu,
       m.prix AS prix_menu,
       SUM(cm.quantite * p.prix) AS somme_a_la_carte,
       SUM(cm.quantite * p.prix) - m.prix AS economie
FROM plat m
JOIN composition_menu cm ON cm.id_menu = m.id_plat
JOIN plat p ON p.id_plat = cm.id_plat
WHERE m.est_menu
GROUP BY m.id_plat, m.nom_plat, m.prix
ORDER BY m.id_plat;
