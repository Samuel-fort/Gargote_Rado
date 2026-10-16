CREATE TABLE plat (
  id_plat SERIAL PRIMARY KEY,
  nom_plat VARCHAR(100) NOT NULL,
  prix INTEGER NOT NULL
);

INSERT INTO plat (nom_plat, prix)
VALUES
  ('Romazava',7000),
  ('Ravitoto sy henakisoa Plat malagasy', 8000),
  ('Akoho sy voanio', 8500),
  ('Mi sao', 6000),
  ('Soupe chinoise', 5000),
  ('Mofo gasy (les 4)', 1000),
  ('Ranon''ampango', 500);
