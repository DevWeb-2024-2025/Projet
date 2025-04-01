DROP DATABASE IF EXISTS ecoleConnectee;
CREATE DATABASE ecoleConnectee;
USE ecoleConnectee;

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
    disponible BOOLEAN  DEFAULT TRUE,
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