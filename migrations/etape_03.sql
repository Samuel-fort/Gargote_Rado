CREATE TABLE commande (
    id_commande SERIAL PRIMARY KEY,
    date_commande DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE ligne_commande (
    id_commande INTEGER NOT NULL REFERENCES commande(id_commande),
    id_plat INTEGER NOT NULL REFERENCES plat(id_plat),
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (id_commande, id_plat)
);

INSERT INTO commande (date_commande) VALUES
  ('2026-10-12'),
  ('2026-10-12'),
  ('2026-10-13'),
  ('2026-10-14');

INSERT INTO ligne_commande (id_commande, id_plat, quantite) VALUES
  (1, 1, 2),
  (1, 7, 2),
  (2, 4, 1),
  (2, 5, 1),
  (2, 6, 1),
  (3, 3, 3),
  (3, 7, 3),
  (4, 2, 1),
  (4, 1, 1);
