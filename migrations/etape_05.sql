CREATE TABLE serveur (
    id_serveur SERIAL PRIMARY KEY,
    nom_serveur VARCHAR(100) NOT NULL
);

CREATE TABLE table_salle (
    id_table SERIAL PRIMARY KEY,
    numero INTEGER NOT NULL UNIQUE
);

INSERT INTO serveur (nom_serveur) VALUES
  ('Njaka Rakoto'),
  ('Lalao Rasoa');

INSERT INTO table_salle (numero) VALUES
  (1), (2), (3), (4), (5), (6), (7), (8);

ALTER TABLE commande
ADD COLUMN id_serveur INTEGER REFERENCES serveur(id_serveur);

ALTER TABLE commande
ADD COLUMN id_table INTEGER REFERENCES table_salle(id_table);

UPDATE commande SET id_serveur = 1 WHERE id_commande IN (1, 2);
UPDATE commande SET id_serveur = 2 WHERE id_commande IN (3, 4);

UPDATE commande SET id_table = 3 WHERE id_commande = 1;
UPDATE commande SET id_table = 5 WHERE id_commande = 3;
UPDATE commande SET id_table = 1 WHERE id_commande = 4;

ALTER TABLE commande
ALTER COLUMN id_serveur SET NOT NULL;
