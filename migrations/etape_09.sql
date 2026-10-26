ALTER TABLE plat
ADD COLUMN est_menu BOOLEAN NOT NULL DEFAULT FALSE;

INSERT INTO categorie (nom_categorie) VALUES
  ('Menus');

INSERT INTO plat (nom_plat, prix, id_categorie, est_menu)
VALUES ('Menu Romazava', 8000, 6, TRUE);

CREATE TABLE composition_menu (
    id_menu INTEGER NOT NULL REFERENCES plat(id_plat),
    id_plat INTEGER NOT NULL REFERENCES plat(id_plat),
    quantite INTEGER NOT NULL DEFAULT 1 CHECK (quantite > 0),
    PRIMARY KEY (id_menu, id_plat),
    CONSTRAINT ck_menu_pas_lui_meme CHECK (id_menu <> id_plat)
);

INSERT INTO composition_menu (id_menu, id_plat, quantite) VALUES
  (8, 1, 1),
  (8, 7, 1),
  (8, 6, 1);

INSERT INTO historique_prix (id_plat, date_debut, prix) VALUES
  (8, '2026-10-17', 8000);

INSERT INTO commande (date_commande, id_serveur, id_table) VALUES
  ('2026-10-17', 2, 4);

INSERT INTO ligne_commande (id_commande, id_plat, quantite, prix_unitaire) VALUES
  (6, 8, 2, 8000);
