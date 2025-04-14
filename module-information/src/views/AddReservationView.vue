<template>
  <div class="add-reservation">
    <h2>✨ Créer une nouvelle réservation</h2>

    <form @submit.prevent="submitReservation">

      <!-- Étape 1 : Dates -->
      <div class="form-group">
        <label>Date de début :</label>
        <input type="datetime-local" v-model="form.date_debut" required>
      </div>

      <div class="form-group">
        <label>Date de fin :</label>
        <input type="datetime-local" v-model="form.date_fin" required>
      </div>

      <!-- Étape 2 : Type de réservation -->
      <div class="form-group">
        <label>Type de réservation :</label>
        <select v-model="form.type" required>
          <option disabled value="">-- Choisissez un type --</option>
          <option v-for="type in typesReservationAutorises" :key="type" :value="type">
  {{ getLabelForType(type) }}
</option>

        </select>
      </div>

      <!-- Étape 3 : Détails selon le type -->

      <!-- SALLE -->
      <div v-if="form.type === 'salle'" class="form-group">
        <label>Nom de la salle :</label>
        <select v-model="form.salle_id" required>
          <option disabled value="">-- Choisissez une salle --</option>
          <option v-for="salle in salles" :key="salle.id" :value="salle.id">{{ salle.nom }}</option>
        </select>
      </div>

      <!-- POSTE -->
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
  <option v-for="poste in postes" :key="poste.id" :value="poste.id">
    Poste #{{ poste.id }}
  </option>
</select>

        </div>
      </div>

      <!-- MATERIEL -->
      <div v-if="form.type === 'materiel'" class="form-group">
        <label>Type de matériel :</label>
        <select v-model="form.type_materiel" required>
          <option v-for="type in typeMaterielAutorises" :key="type" :value="type">
  {{ getLabelForType(type)  }}
</option>

        </select>

        <label v-if="materiels.length">Choisissez un matériel :</label>
        <select v-if="materiels.length" v-model="form.materiel_id" required>
          <option disabled value="">-- Matériel disponible --</option>
          <option v-for="m in materiels" :key="m.id" :value="m.id">{{ m.nom }}</option>
        </select>
      </div>

      <!-- APERÇU -->
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
        date_fin: '',
        materiel_id:''
        

      },
      salles: [],
      postes: [],
      materiels: [],
      points : 0
    };
  },

  computed: {
  niveau() {
    const pts = this.points;
    if (pts >= 200) return 'expert';
    if (pts >= 100) return 'confirme';
    if (pts >= 50) return 'intermediaire';
    return 'debutant';
  },
  typeMaterielAutorises() {
    const base = ['livre', 'clavier', 'souris'];
    const inter = base.concat(['camera', 'videoprojecteur', 'ordinateur', 'tablette']);
    const full = inter.concat(['salle']);

    switch (this.niveau) {
      case 'expert':
      case 'confirme':
        return full;
      case 'intermediaire':
        return inter;
      default:
        return base;
    }
  },
  typesReservationAutorises() {
  switch (this.niveau) {
    case 'expert':
    case 'confirme':
      return ['salle', 'poste', 'materiel'];
    case 'intermediaire':
    case 'debutant':
      return ['poste', 'materiel']; // pas de salle
  }
}

},


  watch: {
    'form.type_materiel': 'tryFetchMateriels',
    'form.date_debut': 'tryFetchMateriels',
    'form.date_fin': 'tryFetchMateriels',
    'form.date_debut': 'tryFetchSalles',
    'form.date_fin': 'tryFetchSalles',
    'form.type': 'tryFetchSalles',
    'form.date_debut': 'tryFetchPostes',
  'form.date_fin': 'tryFetchPostes',
  'form.salle_id': 'tryFetchPostes'

  },

  mounted() {
  const token = localStorage.getItem("token");

  // 1. Récupère les points de l'utilisateur
  fetch("http://localhost/ecole_connectee/api/etudiant/get_profil.php", {
    headers: {
      Authorization: "Bearer " + token
    }
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        this.points = data.points;
        // Une fois les points récupérés, tu peux déclencher les chargements
        this.tryFetchMateriels();
        this.tryFetchSalles();
        this.tryFetchPostes();
      }
    })
    .catch(err => console.error("Erreur récupération points :", err));
},



  methods: {

    getLabelForType(type) {
  const labels = {
    livre: "📚 Livre",
    clavier: "⌨️ Clavier",
    souris: "🖱️ Souris",
    poste: "💻 Poste informatique",
    camera: "🎥 Caméra",
    videoprojecteur: "📽️ Vidéoprojecteur",
    ordinateur: "💻 Ordinateur",
    tablette: "📱 Tablette",
    salle: "🏫 Salle",
    materiel: "📦 Materiel"

  };
  return labels[type] || type;
},


    async tryFetchMateriels() {
      if (this.form.type_materiel && this.form.date_debut && this.form.date_fin) {
        await this.fetchMateriels();
      }
    },

    async tryFetchPostes() {
  if (this.form.type === 'poste' && this.form.salle_id && this.form.date_debut && this.form.date_fin) {
    await this.fetchPostes();
  }
},


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
      if (this.form.type === 'materiel') {
  payload.type_materiel = this.form.type_materiel;
  payload.materiel_id = this.form.materiel_id; // ✅ AJOUTE ÇA
}


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
        console.error("Erreur fetch:", err);
        alert("⚠️ Erreur de connexion au serveur.");
      }
    },

    async fetchMateriels() {
  this.form.materiel_id = '';
  this.materiels = [];

  // Ne continue que si on est dans une réservation de matériel
  if (this.form.type !== 'materiel') return;

  if (!this.form.type_materiel || !this.form.date_debut || !this.form.date_fin) {
    alert("Veuillez remplir type de matériel + dates avant !");
    return;
  }

  const url = `http://localhost/ecole_connectee/api/materiel/get_disponibles.php?type=${this.form.type_materiel}&date_debut=${this.form.date_debut}&date_fin=${this.form.date_fin}`;

  try {
    const res = await fetch(url);
    const data = await res.json();

    if (data.success) {
      this.materiels = data.materiels;
    } else {
      alert(data.message || "Aucun matériel trouvé.");
    }
  } catch (err) {
    alert("Erreur lors du chargement des matériels.");
  }
},

async tryFetchSalles() {
  if ((this.form.type === 'salle' || this.form.type === 'poste') && this.form.date_debut && this.form.date_fin) {
    await this.fetchSalles();
  }
},


async fetchSalles() {
  this.form.salle_id = '';
  this.salles = [];

  const url = `http://localhost/ecole_connectee/api/salle/salle_disponible.php?date_debut=${this.form.date_debut}&date_fin=${this.form.date_fin}`;

  try {
    const res = await fetch(url);
    const data = await res.json();

    if (data.success) {
      this.salles = data.salles;
    } else {
      alert(data.message || "Erreur lors du chargement des salles.");
    }
  } catch (err) {
    alert("Erreur lors de la récupération des salles.");
  }
},

async fetchPostes() {
  this.form.poste_id = '';
  this.postes = [];

  if (!this.form.salle_id || !this.form.date_debut || !this.form.date_fin) return;

  const url = `http://localhost/ecole_connectee/api/poste/get_postes_disponibles.php?salle_id=${this.form.salle_id}&date_debut=${this.form.date_debut}&date_fin=${this.form.date_fin}`;

  try {
    const res = await fetch(url);
    const data = await res.json();

    if (data.success) {
      this.postes = data.postes;
    } else {
      alert(data.message || "Aucun poste disponible.");
    }
  } catch (err) {
    alert("Erreur lors du chargement des postes.");
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
