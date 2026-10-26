CREATE TABLE ingredient (
    id_ingredient SERIAL PRIMARY KEY,
    nom_ingredient VARCHAR(100) NOT NULL UNIQUE,
    unite VARCHAR(10) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE composition_plat (
    id_plat INTEGER NOT NULL REFERENCES plat(id_plat),
    id_ingredient INTEGER NOT NULL REFERENCES ingredient(id_ingredient),
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (id_plat, id_ingredient)
);

INSERT INTO ingredient (nom_ingredient, unite, stock) VALUES
  ('Riz', 'g', 50000),
  ('Viande de zébu', 'g', 20000),
  ('Brèdes mafana', 'g', 8000),
  ('Henakisoa', 'g', 10000),
  ('Feuilles de manioc pilées', 'g', 6000),
  ('Poulet', 'g', 12000),
  ('Lait de coco', 'ml', 20000),
  ('Nouilles chinoises', 'g', 9000),
  ('Légumes', 'g', 15000),
  ('Farine de riz', 'g', 10000),
  ('Sucre', 'g', 8000),
  ('Eau', 'ml', 200000);

INSERT INTO composition_plat (id_plat, id_ingredient, quantite) VALUES
  (1, 1, 250),
  (1, 2, 150),
  (1, 3, 100),
  (2, 1, 250),
  (2, 4, 150),
  (2, 5, 100),
  (3, 1, 250),
  (3, 6, 200),
  (3, 7, 150),
  (4, 8, 200),
  (4, 9, 100),
  (4, 6, 80),
  (5, 8, 120),
  (5, 9, 80),
  (5, 6, 60),
  (5, 12, 300),
  (6, 10, 150),
  (6, 11, 30),
  (7, 1, 40),
  (7, 12, 300);
