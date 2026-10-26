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

UPDATE plat SET id_categorie = 1 WHERE id_plat IN (1, 2, 3);
UPDATE plat SET id_categorie = 2 WHERE id_plat = 4;
UPDATE plat SET id_categorie = 3 WHERE id_plat = 5;
UPDATE plat SET id_categorie = 4 WHERE id_plat = 6;
UPDATE plat SET id_categorie = 5 WHERE id_plat = 7;

ALTER TABLE plat
ADD CONSTRAINT fk_plat_categorie
FOREIGN KEY (id_categorie)
REFERENCES categorie(id_categorie);

ALTER TABLE plat
ALTER COLUMN id_categorie SET NOT NULL;
