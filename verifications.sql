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
