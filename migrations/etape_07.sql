ALTER TABLE ligne_commande
ADD COLUMN prix_unitaire INTEGER;

UPDATE ligne_commande
SET prix_unitaire = (SELECT p.prix FROM plat p WHERE p.id_plat = ligne_commande.id_plat);

ALTER TABLE ligne_commande
ALTER COLUMN prix_unitaire SET NOT NULL;

CREATE TABLE historique_prix (
    id_plat INTEGER NOT NULL REFERENCES plat(id_plat),
    date_debut DATE NOT NULL,
    prix INTEGER NOT NULL CHECK (prix > 0),
    PRIMARY KEY (id_plat, date_debut)
);

INSERT INTO historique_prix (id_plat, date_debut, prix)
SELECT id_plat, DATE '2026-01-01', prix FROM plat;

UPDATE plat SET prix = 7500 WHERE id_plat = 1;

INSERT INTO historique_prix (id_plat, date_debut, prix) VALUES
  (1, '2026-10-15', 7500);

INSERT INTO commande (date_commande, id_serveur, id_table) VALUES
  ('2026-10-16', 1, 2);

INSERT INTO ligne_commande (id_commande, id_plat, quantite, prix_unitaire) VALUES
  (5, 1, 2, 7500),
  (5, 7, 2, 500);
