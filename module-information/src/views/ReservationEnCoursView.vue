<template>
    <div class="filtre-type">
  <label for="filtre">🔎 Filtrer par type :</label>
  <select id="filtre" v-model="filtreType">
    <option value="">Tous les types</option>
    <option value="salle">🏫 Salle</option>
    <option value="poste">💻 Poste</option>
    <option value="materiel">🎒 Matériel</option>
  </select>

  <!-- Sous-filtre selon le type -->
  <template v-if="filtreType === 'materiel'">
    <label for="type-materiel">Type de matériel :</label>
    <input id="type-materiel" v-model="filtreMateriel" placeholder="ex : clavier, souris..." />
  </template>

  <template v-if="filtreType === 'salle'">
    <label for="salle">Nom de la salle :</label>
    <input id="salle" v-model="filtreSalle" placeholder="ex : B203..." />
  </template>

  <template v-if="filtreType === 'poste'">
    <label for="poste">Numéro ou salle du poste :</label>
    <input id="poste" v-model="filtrePoste" placeholder="ex : 4 ou B203" />
  </template>
</div>


    <div class="reservations-container">
      <h2>📌 Réservations en cours</h2>

     
      <div v-if="reservations.length === 0" class="no-reservation">
        Aucune réservation en cours.
      </div>

      
      <ul class="reservation-list">
        <li v-for="res in filteredReservations" :key="res.id" class="reservation-card">
          <p><strong>Type :</strong> {{ res.type }}</p>
  
          <template v-if="res.type === 'salle'">
            <p>🏫 Salle : <strong>{{ res.salle_nom }}</strong></p>
          </template>
  
          <template v-if="res.type === 'poste'">
            <p>💻 Poste : <strong>#{{ res.poste_numero }}</strong></p>
            <p>📍 Salle : <strong>{{ res.salle_nom }}</strong></p>
          </template>
  
          <template v-if="res.type === 'materiel'">
            <p>🎒 Matériel : <strong>{{ res.materiel_nom }}</strong></p>
          </template>
  
          <p>🕐 Du {{ formatDate(res.date_debut) }} au {{ formatDate(res.date_fin) }}</p>
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        reservations: [],
        filtreType: '',
        filtreMateriel: '',
        filtreSalle: '',
        filtrePoste: ''

      };
    },


        computed: {
  filteredReservations() {
    return this.reservations.filter(res => {
      // Si aucun filtre de type sélectionné
      if (!this.filtreType) return true;

      // 1. Filtrage principal par type
      if (res.type !== this.filtreType) return false;

      // 2. Filtrage spécifique par sous-type
      if (this.filtreType === 'materiel' && this.filtreMateriel) {
        return res.materiel_nom?.toLowerCase().includes(this.filtreMateriel.toLowerCase());
      }

      if (this.filtreType === 'salle' && this.filtreSalle) {
        return res.salle_nom?.toLowerCase().includes(this.filtreSalle.toLowerCase());
      }

      if (this.filtreType === 'poste' && this.filtrePoste) {
        const posteMatch = res.poste_numero?.toString().includes(this.filtrePoste);
        const salleMatch = res.salle_nom?.toLowerCase().includes(this.filtrePoste.toLowerCase());
        return posteMatch || salleMatch;
      }

      return true; // Aucun sous-filtre rempli → ok
    });
  }
},


    mounted() {
      fetch("http://localhost/ecole_connectee/api/get_reservations_publiques.php")
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            this.reservations = data.reservations;
          } else {
            console.error(data.message);
          }
        })
        .catch(err => {
          console.error("Erreur fetch :", err);
          alert("Erreur lors du chargement des réservations.");
        });
    },
    methods: {
      formatDate(dateStr) {
        const options = {
          weekday: "short",
          year: "numeric",
          month: "short",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit"
        };
        return new Date(dateStr).toLocaleDateString("fr-FR", options);
      }
    }
  };
  </script>
  
  <style scoped>
  .reservations-container {
    max-width: 800px;
    margin: 40px auto;
    padding: 20px;
    font-family: 'Segoe UI', sans-serif;
  }
  
  h2 {
    font-size: 24px;
    margin-bottom: 20px;
    color: #333;
  }
  
  .no-reservation {
    font-style: italic;
    color: #777;
    text-align: center;
    margin-top: 20px;
  }
  
  .reservation-list {
    list-style: none;
    padding: 0;
  }
  
  .reservation-card {
    background: #f9f9f9;
    border-left: 6px solid #4caf50;
    padding: 16px;
    border-radius: 10px;
    margin-bottom: 16px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.05);
  }
  
  .reservation-card p {
    margin: 6px 0;
    font-size: 15px;
  }

  .filtre-type {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 25px;
  background: #f1f1f1;
  padding: 12px 16px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.filtre-type label {
  font-weight: bold;
  font-size: 16px;
  color: #333;
}

.filtre-type select {
  padding: 8px 12px;
  border-radius: 8px;
  border: 1px solid #ccc;
  font-size: 14px;
  background-color: white;
  color: #333;
  transition: border-color 0.3s;
}

.filtre-type select:focus {
  border-color: #4caf50;
  outline: none;
}
   
  </style>
  