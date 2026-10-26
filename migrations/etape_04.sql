CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom_client VARCHAR(100) NOT NULL,
    telephone VARCHAR(20)
);

ALTER TABLE commande
ADD COLUMN id_client INTEGER REFERENCES client(id_client);

INSERT INTO client (nom_client, telephone) VALUES
  ('Hery Andrianina', '034 12 345 67'),
  ('Voahangy Razafy', NULL),
  ('Tsiory Rakotomalala', '032 98 765 43');

UPDATE commande SET id_client = 1 WHERE id_commande = 1;
UPDATE commande SET id_client = 2 WHERE id_commande = 3;
