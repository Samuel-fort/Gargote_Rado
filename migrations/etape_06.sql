CREATE TABLE mode_paiement (
    id_mode SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE paiement (
    id_paiement SERIAL PRIMARY KEY,
    id_commande INTEGER NOT NULL REFERENCES commande(id_commande),
    id_mode INTEGER NOT NULL REFERENCES mode_paiement(id_mode),
    montant INTEGER NOT NULL CHECK (montant > 0),
    reference_transaction VARCHAR(50),
    date_paiement DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO mode_paiement (libelle) VALUES
  ('Espèces'),
  ('MVola'),
  ('Orange Money'),
  ('Airtel Money');

INSERT INTO paiement (id_commande, id_mode, montant, reference_transaction, date_paiement) VALUES
  (1, 1, 10000, NULL, '2026-10-12'),
  (1, 2, 5000, 'MV261012A4F7', '2026-10-12'),
  (2, 3, 6000, 'OM261012K92B', '2026-10-12');
