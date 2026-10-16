-- Creation de la table catégorie
CREATE TABLE categorie (
    id_categorie SERIAL PRIMARY KEY,
    nom_categorie VARCHAR(100) NOT NULL
);

ALTER TABLE plat
ADD COLUMN id_categorie INTEGER;

INSERT INTO categorie (nom_categorie)
VALUES
  ('Plats malagasy'),
  ('Plats chinois'),
  ('Soupes'),
  ('Desserts et goûter'),
  ('Boissons');

  
-- les plats malagasy (catégorie 1)
UPDATE plat SET id_categorie = 1 WHERE id_plat IN (1, 2, 3);

-- Mi sao  plats chinois (catégorie 2)
UPDATE plat SET id_categorie = 2 WHERE id_plat = 4;

-- Soupe chinoise soupes (catégorie 3)
UPDATE plat SET id_categorie = 3 WHERE id_plat = 5;

-- Mofo gasy desserts et goûters (catégorie 4)
UPDATE plat SET id_categorie = 4 WHERE id_plat = 6;

-- Ranon'ampango boissons (catégorie 5)
UPDATE plat SET id_categorie = 5 WHERE id_plat = 7;

-- Ajout de clé étrangère entre plat et categorie

ALTER TABLE plat
ADD CONSTRAINT fk_plat_categorie
FOREIGN KEY (id_categorie)
REFERENCES categorie(id_categorie);

-- Obliger la catégorie
ALTER TABLE plat
ALTER COLUMN id_categorie SET NOT NULL;
