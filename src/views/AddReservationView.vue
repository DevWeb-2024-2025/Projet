<template>
  <div class="add-reservation">
    <h2>✨ Créer une nouvelle réservation</h2>

    <form @submit.prevent="submitReservation">
      <div class="form-group">
        <label>Type de réservation :</label>
        <select v-model="form.type" required>
          <option disabled value="">-- Choisissez un type --</option>
          <option value="salle">Salle</option>
          <option value="poste">Poste</option>
          <option value="materiel">Matériel</option>
        </select>
      </div>

      <div v-if="form.type === 'salle'" class="form-group">
        <label>Nom de la salle :</label>
        <select v-model="form.salle_id" required>
          <option disabled value="">-- Choisissez une salle --</option>
          <option v-for="salle in salles" :key="salle.id" :value="salle.id">{{ salle.nom }}</option>
        </select>
      </div>

      <div v-if="form.type === 'poste'">
        <div class="form-group">
          <label>Salle du poste :</label>
          <select v-model="form.salle_id" required>
            <option disabled value="">-- Choisissez une salle --</option>
            <option v-for="salle in salles" :key="salle.id" :value="salle.id">{{ salle.nom }}</option>
          </select>
        </div>

        <div class="form-group">
          <label>Numéro du poste :</label>
          <select v-model="form.poste_id" required>
            <option disabled value="">-- Choisissez un poste --</option>
            <option v-for="poste in postes" :key="poste.id" :value="poste.id">Poste #{{ poste.numero }}</option>
          </select>
        </div>
      </div>

      <div v-if="form.type === 'materiel'" class="form-group">
        <label>Type de matériel :</label>
        <select v-model="form.type_materiel" required>
          <option disabled value="">-- Choisissez un type --</option>
          <option>livre</option>
          <option>ordinateur</option>
          <option>tablette</option>
          <option>videoprojecteur</option>
          <option>camera</option>
          <option>clavier</option>
          <option>souris</option>
        </select>
      </div>

      <div class="form-group">
        <label>Date de début :</label>
        <input type="datetime-local" v-model="form.date_debut" required>
      </div>

      <div class="form-group">
        <label>Date de fin :</label>
        <input type="datetime-local" v-model="form.date_fin" required>
      </div>

      <div class="preview">
        <h4>Aperçu :</h4>
        <p v-if="form.type">Type : <strong>{{ form.type }}</strong></p>
        <p v-if="form.type === 'salle' && form.salle_id">Salle ID : <strong>{{ form.salle_id }}</strong></p>
        <p v-if="form.type === 'poste' && form.poste_id">Poste ID : <strong>{{ form.poste_id }}</strong></p>
        <p v-if="form.type === 'materiel'">Matériel : <strong>{{ form.type_materiel }}</strong></p>
        <p v-if="form.date_debut">Début : <strong>{{ form.date_debut }}</strong></p>
        <p v-if="form.date_fin">Fin : <strong>{{ form.date_fin }}</strong></p>
      </div>

      <button type="submit">📅 Réserver maintenant</button>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        type: '',
        salle_id: '',
        poste_id: '',
        type_materiel: '',
        date_debut: '',
        date_fin: ''
      },
      salles: [
        { id: 1, nom: "Salle 101" },
        { id: 2, nom: "Salle 102" }
      ],
      postes: [
        { id: 1, numero: 1 },
        { id: 2, numero: 2 },
        { id: 3, numero: 3 }
      ]
    };
  },
  methods: {
    async submitReservation() {
      const token = localStorage.getItem("token");
      if (!token) return alert("Connectez-vous pour réserver !");

      const payload = {
        type: this.form.type,
        date_debut: this.form.date_debut,
        date_fin: this.form.date_fin
      };

      if (this.form.type === 'salle') payload.salle_id = this.form.salle_id;
      if (this.form.type === 'poste') Object.assign(payload, {
        salle_id: this.form.salle_id,
        poste_id: this.form.poste_id
      });
      if (this.form.type === 'materiel') payload.type_materiel = this.form.type_materiel;

      try {
        const res = await fetch("http://localhost/ecole_connectee/api/etudiant/add_reservation.php", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + token
          },
          body: JSON.stringify(payload)
        });

        const text = await res.text();
        const data = JSON.parse(text);

        if (data.success) {
          alert("✅ Réservation effectuée !");
          this.$router.push("/reservations");
        } else {
          alert(data.message || "Erreur lors de l'ajout.");
        }
      } catch (err) {
        alert("⚠️ Erreur de connexion au serveur.");
      }
    }
  }
};
</script>

<style scoped>
.add-reservation {
  background: #ffffff;
  max-width: 650px;
  margin: 40px auto;
  padding: 40px;
  border-radius: 20px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
  font-family: 'Segoe UI', sans-serif;
}

h2 {
  text-align: center;
  color: #222;
  margin-bottom: 25px;
}

.form-group {
  margin-bottom: 20px;
}

label {
  font-weight: 600;
  margin-bottom: 5px;
  display: block;
  color: #333;
}

input,
select {
  width: 100%;
  padding: 10px;
  font-size: 16px;
  border-radius: 8px;
  border: 1px solid #ccc;
  box-sizing: border-box;
  margin-top: 5px;
  transition: 0.3s;
}

input:focus,
select:focus {
  outline: none;
  border-color: #4caf50;
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
}

button {
  margin-top: 25px;
  padding: 14px;
  background: linear-gradient(to right, #4caf50, #66bb6a);
  color: white;
  font-size: 16px;
  font-weight: bold;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  width: 100%;
  transition: 0.3s ease;
}

button:hover {
  background: linear-gradient(to right, #388e3c, #4caf50);
}

.preview {
  background: #f9f9f9;
  border: 1px dashed #ccc;
  padding: 15px;
  border-radius: 8px;
  margin-top: 20px;
  font-size: 15px;
  color: #444;
}
</style>
