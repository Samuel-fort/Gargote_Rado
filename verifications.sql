-- ETAPE 1 : verification des plats du plus cher au moins cher
SELECT current_database();
SELECT * FROM plat ORDER BY prix DESC;

-- ETAPE 2 : verification des catégories
SELECT * FROM plat WHERE id_categorie IS NOT NULL;
SELECT id_plat , nom_plat, prix, id_categorie FROM plat ORDER BY id_plat;

-- Afficher catégories
SELECT id_categorie, nom_categorie FROM categorieORDER BY id_categorie;

-- Verification des asociations 
SELECT p.id_plat, p.nom_plat, c.nom_categorie
FROM plat p
JOIN categorie c
ON p.id_categorie = c.id_categorie
ORDER BY p.id_plat;

--  nombre de plats par categorie
SELECT c.nom_categorie, COUNT(p.id_plat) AS nombre_plats
FROM categorie c
LEFT JOIN plat p
ON c.id_categorie = p.id_categorie
GROUP BY c.id_categorie, c.nom_categorie
ORDER BY c.id_categorie;