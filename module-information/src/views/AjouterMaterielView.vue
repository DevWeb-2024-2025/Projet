<template>
    <div class="add-materiel-container">
      <h2>➕ Ajouter un nouveau matériel</h2>
  
      <form @submit.prevent="ajouterMateriel">
        <label>Nom :</label>
        <input v-model="form.nom" required />
  
        <label>Type :</label>
        <select v-model="form.type" required>
          <option disabled value="">-- Choisir un type --</option>
          <option v-for="t in types" :key="t" :value="t">{{ t }}</option>
        </select>
  
        <label>État :</label>
        <select v-model="form.etat" required>
          <option value="neuf">Neuf</option>
          <option value="bon">Bon</option>
          <option value="usé">Usé</option>
          <option value="hors service">Hors service</option>
        </select>
  
        <!-- Champs dynamiques selon le type -->
        <div v-if="form.type === 'ordinateur'">
          <label>Marque :</label><input v-model="form.marque" required />
          <label>Processeur :</label><input v-model="form.processeur" required />
          <label>RAM (Go) :</label><input type="number" v-model.number="form.ram" required />
          <label>Stockage (Go) :</label><input type="number" v-model.number="form.stockage" required />
        </div>
  
        <div v-if="form.type === 'livre'">
          <label>Auteur :</label><input v-model="form.auteur" required />
          <label>ISBN :</label><input v-model="form.isbn" required />
        </div>
  
        <div v-if="form.type === 'tablette'">
          <label>Marque :</label><input v-model="form.marque" required />
          <label>Modèle :</label><input v-model="form.modele" required />
          <label>Stockage :</label><input type="number" v-model.number="form.stockage" required />
          <label>Batterie :</label>
          <select v-model="form.batterie" required>
            <option value="excellente">Excellente</option>
            <option value="bonne">Bonne</option>
            <option value="moyenne">Moyenne</option>
            <option value="faible">Faible</option>
          </select>
        </div>
  
        <div v-if="form.type === 'videoprojecteur'">
          <label>Marque :</label><input v-model="form.marque" required />
          <label>Technologie :</label><input v-model="form.technologie" required />
          <label>Heures d'utilisation :</label><input type="number" v-model.number="form.heures_utilisation" required />
        </div>
  
        <div v-if="form.type === 'camera'">
          <label>Marque :</label><input v-model="form.marque" required />
          <label>Modèle :</label><input v-model="form.model" required />
          <label>Autonomie (min) :</label><input type="number" v-model.number="form.autonomie" required />
          <label>Type :</label><input v-model="form.camera_type" required />
        </div>
  
        <div v-if="form.type === 'clavier'">
          <label>Marque :</label><input v-model="form.marque" required />
          <label>Modèle :</label><input v-model="form.model" required />
          <label>Disposition :</label>
          <select v-model="form.disposition" required>
            <option value="AZERTY">AZERTY</option>
            <option value="QWERTY">QWERTY</option>
            <option value="autre">Autre</option>
          </select>
        </div>
  
        <div v-if="form.type === 'souris'">
          <label>Marque :</label><input v-model="form.marque" required />
          <label>Modèle :</label><input v-model="form.model" required />
          <label>Type :</label>
          <select v-model="form.souris_type" required>
            <option value="filaire">Filaire</option>
            <option value="sans fil">Sans fil</option>
          </select>
        </div>
  
        <button type="submit">Ajouter</button>
      </form>
  
      <p v-if="message" :class="messageType">{{ message }}</p>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        types: ['ordinateur', 'livre', 'tablette', 'videoprojecteur', 'camera', 'clavier', 'souris'],
        form: {
          nom: '',
          type: '',
          etat: ''
        },
        message: '',
        messageType: ''
      }
    },
    methods: {
        async ajouterMateriel() {
  const token = localStorage.getItem("token");

  // Construction dynamique du champ `details`
  const details = {};
  switch (this.form.type) {
    case 'ordinateur':
      details.marque = this.form.marque;
      details.model = this.form.nom; // ou form.model si tu veux l'ajouter
      details.processeur = this.form.processeur;
      details.ram = this.form.ram;
      details.stockage = this.form.stockage;
      break;
    case 'livre':
      details.auteur = this.form.auteur;
      details.isbn = this.form.isbn;
      break;
    case 'tablette':
      details.marque = this.form.marque;
      details.modele = this.form.modele;
      details.stockage = this.form.stockage;
      details.batterie = this.form.batterie;
      break;
    case 'videoprojecteur':
      details.marque = this.form.marque;
      details.technologie = this.form.technologie;
      details.heures_utilisation = this.form.heures_utilisation;
      break;
    case 'camera':
      details.marque = this.form.marque;
      details.model = this.form.model;
      details.type = this.form.camera_type;
      details.autonomie = this.form.autonomie;
      break;
    case 'clavier':
      details.marque = this.form.marque;
      details.model = this.form.model;
      details.disposition = this.form.disposition;
      break;
    case 'souris':
      details.marque = this.form.marque;
      details.model = this.form.model;
      details.type = this.form.souris_type;
      break;
  }

  const payload = {
    nom: this.form.nom,
    type: this.form.type,
    etat: this.form.etat,
    disponible: true,
    details: details
  };

  const res = await fetch("http://localhost/ecole_connectee/api/enseignant/add_materiel.php", {
    method: "POST",
    headers: {
      'Content-Type': 'application/json',
      Authorization: 'Bearer ' + token
    },
    body: JSON.stringify(payload)
  });

  const data = await res.json();
  if (data.success) {
    this.message = "✅ Matériel ajouté avec succès";
    this.messageType = "success";
    this.form = { nom: '', type: '', etat: '' }; // reset
  } else {
    this.message = data.message || "Erreur lors de l'ajout.";
    this.messageType = "error";
  }
}

    }
  };
  </script>
  
  <style scoped>
  .add-materiel-container {
    max-width: 700px;
    margin: auto;
    padding: 30px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    font-family: 'Segoe UI', sans-serif;
  }
  
  form label {
    display: block;
    margin: 10px 0 5px;
    font-weight: bold;
  }
  
  form input,
  form select,
  form textarea {
    width: 100%;
    padding: 10px;
    border-radius: 8px;
    border: 1px solid #ccc;
    margin-bottom: 15px;
    box-sizing: border-box;
  }
  
  button {
    background: #4caf50;
    color: white;
    border: none;
    padding: 12px 20px;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
  }
  
  button:hover {
    background: #388e3c;
  }
  
  .success {
    color: green;
    font-weight: bold;
    margin-top: 15px;
  }
  .error {
    color: red;
    font-weight: bold;
    margin-top: 15px;
  }
  </style>
  