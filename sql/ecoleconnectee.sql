DROP DATABASE IF EXISTS ecoleconnectee;
CREATE DATABASE ecoleconnectee;
USE ecoleconnectee;

-- Table des utilisateurs (générique pour étudiants et enseignants)
CREATE TABLE Utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    points INT DEFAULT 0,
    role ENUM('etudiant', 'enseignant', 'admin') NOT NULL
);

-- Table des classes
CREATE TABLE Classe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

-- Table des étudiants
CREATE TABLE Etudiant (
    id INT PRIMARY KEY,
    classe_id INT,
    FOREIGN KEY (id) REFERENCES Utilisateur(id),
    FOREIGN KEY (classe_id) REFERENCES Classe(id)
);

-- Table des enseignants
CREATE TABLE Enseignant (
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES Utilisateur(id)
);


-- Table des matières
CREATE TABLE Matiere (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

-- Relation N:N entre enseignants et classes
CREATE TABLE EnseigneClasse (
    enseignant_id INT,
    classe_id INT,
    PRIMARY KEY (enseignant_id, classe_id),
    FOREIGN KEY (enseignant_id) REFERENCES Enseignant(id),
    FOREIGN KEY (classe_id) REFERENCES Classe(id)
);

-- Relation N:N entre classes et matières
CREATE TABLE ClasseMatiere (
    classe_id INT,
    matiere_id INT,
    PRIMARY KEY (classe_id, matiere_id),
    FOREIGN KEY (classe_id) REFERENCES Classe(id),
    FOREIGN KEY (matiere_id) REFERENCES Matiere(id)
);

-- Relation N:N entre enseignant et matière
CREATE TABLE EnseignantMatiere(
	enseignant_id INT,
    matiere_id INT,
    PRIMARY KEY (enseignant_id, matiere_id),
    FOREIGN KEY (enseignant_id) REFERENCES Enseignant(id),
    FOREIGN KEY (matiere_id) REFERENCES Matiere(id)
);

-- Table des salles
CREATE TABLE Salle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    type ENUM('cours', 'labo', 'amphi') NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    capacite INT NOT NULL
);


-- Table des postes informatiques
CREATE TABLE PosteInformatique (
    id INT AUTO_INCREMENT PRIMARY KEY,
    salle_id INT,
    disponible BOOLEAN  DEFAULT TRUE,
    FOREIGN KEY (salle_id) REFERENCES Salle(id)
);


-- Table des notifications
CREATE TABLE Notification (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT,
    message TEXT NOT NULL,
    date_envoi DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id)
);

CREATE TABLE Materiel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    type ENUM('livre', 'ordinateur', 'tablette', 'videoprojecteur', 'camera','clavier','souris') NOT NULL,
    etat ENUM('neuf', 'bon', 'usé', 'hors service') NOT NULL,
    disponible BOOLEAN  DEFAULT TRUE,
    details JSON NULL -- Stocke les attributs spécifiques selon le type
);

-- Table OrdinateurPortable (hérite de Materiel)
CREATE TABLE OrdinateurPortable (
    id INT PRIMARY KEY,
    model VARCHAR(100),
    marque VARCHAR(50),
    processeur VARCHAR(50),
    ram INT,
    stockage INT,
    FOREIGN KEY (id) REFERENCES Materiel(id) ON DELETE CASCADE
);

-- Table Livre (hérite de Materiel)
CREATE TABLE Livre (
    id INT PRIMARY KEY,
    titre VARCHAR(100),
    auteur VARCHAR(100),
    isbn VARCHAR(20),
    FOREIGN KEY (id) REFERENCES Materiel(id) ON DELETE CASCADE
);

-- Table des Tablettes (hérite de Materiel)
CREATE TABLE Tablette (
    id INT PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    stockage INT NOT NULL, -- Stockage en Go
    batterie ENUM('excellente', 'bonne', 'moyenne', 'faible') NOT NULL,
    FOREIGN KEY (id) REFERENCES Materiel(id) ON DELETE CASCADE
);

-- Table des Vidéoprojecteurs (hérite de Materiel)
CREATE TABLE Videoprojecteur (
    id INT PRIMARY KEY,
    resolution VARCHAR(20) NOT NULL,
    marque VARCHAR(50) NOT NULL,
    technologie ENUM('LED', 'LCD', 'DLP') NOT NULL,
    heures_utilisation INT NOT NULL,
    FOREIGN KEY (id) REFERENCES Materiel(id) ON DELETE CASCADE
);

-- Table des Caméras (hérite de Materiel)
CREATE TABLE Camera (
    id INT PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    marque VARCHAR(50) NOT NULL,
    resolution_mp INT NOT NULL, -- Résolution en mégapixels
    type ENUM('caméra', 'micro-cravate', 'trépied') NOT NULL,
    autonomie INT NOT NULL, -- Autonomie en minutes
    FOREIGN KEY (id) REFERENCES Materiel(id) ON DELETE CASCADE
);

-- Table des Souris (hérite de Materiel)
CREATE TABLE Souris (
    id INT PRIMARY KEY,
    model VARCHAR(100),
    type ENUM('filaire', 'sans fil') NOT NULL,
    marque VARCHAR(50) NOT NULL,
    FOREIGN KEY (id) REFERENCES Materiel(id) ON DELETE CASCADE
);

-- Table des Claviers (hérite de Materiel)
CREATE TABLE Clavier (
    id INT PRIMARY KEY,
    model VARCHAR(100),
    disposition ENUM('AZERTY', 'QWERTY', 'autre') NOT NULL,
    marque VARCHAR(50) NOT NULL,
    FOREIGN KEY (id) REFERENCES Materiel(id) ON DELETE CASCADE
);

-- Table Reservation 
CREATE TABLE Reservation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    type ENUM('salle', 'poste', 'materiel') NOT NULL,
    salle_id INT NULL,
    poste_id INT NULL,
    materiel_id INT NULL,
    date_debut DATETIME NOT NULL,
    date_fin DATETIME NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
    FOREIGN KEY (salle_id) REFERENCES Salle(id),
    FOREIGN KEY (poste_id) REFERENCES PosteInformatique(id),
    FOREIGN KEY (materiel_id) REFERENCES Materiel(id)
);


INSERT INTO Salle (nom, type, capacite) VALUES
('Salle 101', 'cours', 30),
('Labo Chimie', 'labo', 20),
('Amphi A', 'amphi', 100),
('Salle 102', 'cours', 25),
('Labo Physique', 'labo', 15);

INSERT INTO Utilisateur (nom, prenom, email, mot_de_passe, points, role)
VALUES
('Test', 'User1', 'user1@test.com', 'mdp123', 0, 'etudiant'),
('Test', 'User2', 'user2@test.com', 'mdp123', 0, 'enseignant');


INSERT INTO Reservation (utilisateur_id, type, salle_id, date_debut, date_fin)
VALUES
(1, 'salle', 1, '2025-04-10 10:00:00', '2025-04-10 12:00:00'),
(2, 'salle', 3, '2025-04-10 09:00:00', '2025-04-10 11:00:00'); -- Amphi A



-- Materiel
INSERT INTO Materiel (nom, type, etat, disponible) VALUES
('Dell Latitude', 'ordinateur', 'bon', true),
('HP EliteBook', 'ordinateur', 'neuf', true),
('Lenovo ThinkPad', 'ordinateur', 'bon', true),
('Acer Aspire', 'ordinateur', 'usé', true),
('Asus ZenBook', 'ordinateur', 'neuf', true);

-- Détails
INSERT INTO OrdinateurPortable VALUES
(1, 'Latitude', 'Dell', 'i5', 8, 256),
(2, 'EliteBook', 'HP', 'i7', 16, 512),
(3, 'ThinkPad', 'Lenovo', 'Ryzen 5', 8, 256),
(4, 'Aspire', 'Acer', 'i3', 4, 128),
(5, 'ZenBook', 'Asus', 'i7', 16, 1024);

-- Materiel
INSERT INTO Materiel (nom, type, etat, disponible) VALUES
('Le C', 'livre', 'bon', true),
('Python Facile', 'livre', 'neuf', true),
('Linux pratique', 'livre', 'bon', true),
('Algo & Struct', 'livre', 'usé', true),
('SQL pour tous', 'livre', 'bon', true);

-- Détails
INSERT INTO Livre VALUES
(6, 'Le C', 'A. K&R', '978-0131103627'),
(7, 'Python Facile', 'G. Swinnen', '978-2212674720'),
(8, 'Linux pratique', 'T. Bortzmeyer', '978-2100806221'),
(9, 'Algo & Struct', 'N. Wirth', '978-2011401111'),
(10, 'SQL pour tous', 'M. Tournier', '978-2746039243');

INSERT INTO Materiel (nom, type, etat, disponible) VALUES
('iPad', 'tablette', 'neuf', true),
('Galaxy Tab S6', 'tablette', 'bon', true),
('Huawei MatePad', 'tablette', 'bon', true),
('Lenovo Tab M10', 'tablette', 'usé', true),
('Surface Go', 'tablette', 'bon', true);

INSERT INTO Tablette VALUES
(11, 'Apple', 'iPad', 128, 'excellente'),
(12, 'Samsung', 'Galaxy Tab S6', 256, 'bonne'),
(13, 'Huawei', 'MatePad', 64, 'moyenne'),
(14, 'Lenovo', 'Tab M10', 32, 'faible'),
(15, 'Microsoft', 'Surface Go', 128, 'bonne');

INSERT INTO Materiel (nom, type, etat, disponible) VALUES
('Epson EB-S41', 'videoprojecteur', 'usé', true),
('BenQ MW535', 'videoprojecteur', 'bon', true),
('ViewSonic PA503S', 'videoprojecteur', 'usé', true),
('Optoma HD146X', 'videoprojecteur', 'neuf', true),
('LG PH550', 'videoprojecteur', 'bon', true);

INSERT INTO Videoprojecteur VALUES
(16, '800x600', 'Epson', 'LCD', 1200),
(17, '1280x800', 'BenQ', 'DLP', 900),
(18, '800x600', 'ViewSonic', 'DLP', 1000),
(19, '1920x1080', 'Optoma', 'DLP', 1500),
(20, '1280x720', 'LG', 'LED', 600);

INSERT INTO Materiel (nom, type, etat, disponible) VALUES
('Canon EOS M50', 'camera', 'bon', true),
('Sony Alpha 6000', 'camera', 'neuf', true),
('GoPro Hero9', 'camera', 'bon', true),
('Zoom H1n', 'camera', 'bon', true),
('Manfrotto Compact', 'camera', 'bon', true);

INSERT INTO Camera VALUES
(21, 'EOS M50', 'Canon', 24, 'caméra', 120),
(22, 'Alpha 6000', 'Sony', 24, 'caméra', 130),
(23, 'Hero9', 'GoPro', 20, 'caméra', 100),
(24, 'H1n', 'Zoom', 0, 'micro-cravate', 200),
(25, 'Compact', 'Manfrotto', 0, 'trépied', 0);

INSERT INTO Materiel (nom, type, etat, disponible) VALUES
('Corsair K95', 'clavier', 'neuf', true),
('Logitech K380', 'clavier', 'bon', true),
('Razer Cynosa', 'clavier', 'usé', true),
('Apple Magic', 'clavier', 'neuf', true),
('SteelSeries Apex', 'clavier', 'bon', true);

INSERT INTO Clavier VALUES
(26, 'K95', 'AZERTY', 'Corsair'),
(27, 'K380', 'QWERTY', 'Logitech'),
(28, 'Cynosa', 'AZERTY', 'Razer'),
(29, 'Magic Keyboard', 'QWERTY', 'Apple'),
(30, 'Apex', 'autre', 'SteelSeries');

INSERT INTO Materiel (nom, type, etat, disponible) VALUES
('Logitech MX Master', 'souris', 'bon', true),
('HP USB Mouse', 'souris', 'usé', true),
('Razer DeathAdder', 'souris', 'neuf', true),
('Apple Magic Mouse', 'souris', 'bon', true),
('Trust Yvi FX', 'souris', 'bon', true);

INSERT INTO Souris VALUES
(31, 'MX Master', 'sans fil', 'Logitech'),
(32, 'USB Mouse', 'filaire', 'HP'),
(33, 'DeathAdder', 'filaire', 'Razer'),
(34, 'Magic Mouse', 'sans fil', 'Apple'),
(35, 'Yvi FX', 'sans fil', 'Trust');

SELECT m.id, m.nom
FROM materiel m
WHERE m.type = 'ordinateur'
  AND m.disponible = 1
  AND m.id NOT IN (
      SELECT r.materiel_id
      FROM reservation r
      WHERE r.type = 'materiel'
        AND (
          ('2025-04-13 00:10:00' BETWEEN r.date_debut AND r.date_fin)
          OR ('2025-04-12 00:13:00' BETWEEN r.date_debut AND r.date_fin)
          OR (r.date_debut BETWEEN '2025-04-13 00:10:00' AND '2025-04-13 00:12:00')
        )
  );
  
  
  -- Postes pour Salle 101 (id = 1)
INSERT INTO PosteInformatique (salle_id) VALUES
(1), (1), (1), (1);

-- Postes pour Salle 102 (id = 2)
INSERT INTO PosteInformatique (salle_id) VALUES
(2), (2), (2);









