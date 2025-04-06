const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// ⚙️ Connexion à MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',       // change si ton user est différent
  password: 'amine123',       // mets ton mot de passe MySQL
  database: 'ecoleconnectee'
});

db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion MySQL:', err);
    return;
  }
  console.log('✅ Connecté à la base de données MySQL');
});

// 📡 Route pour récupérer les salles
app.get('/salles', (req, res) => {
  db.query('SELECT * FROM Salle', (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// 📡 Route pour récupérer les salles disponibles
app.get('/salles-disponibles', (req, res) => {
    const { type, date } = req.query;
  
    const sql = `
      SELECT * FROM Salle 
      WHERE type = ? 
      AND id NOT IN (
        SELECT salle_id FROM Reservation
        WHERE DATE(?) BETWEEN DATE(date_debut) AND DATE(date_fin)
        AND type = 'salle'
      )
    `;
  
    db.query(sql, [type, date], (err, results) => {
      if (err) return res.status(500).send(err);
      res.json(results);
    });
  });
  

app.listen(3000, () => {
  console.log('🚀 Serveur lancé sur http://localhost:3000');
});
