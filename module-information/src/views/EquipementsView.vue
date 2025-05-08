<template>
    <div class="equipements-container">
      <h2>🧰 Équipements de l'école</h2>
  
      <!-- Filtres -->
      <div class="filtres">
        <label for="filtre-type">Type :</label>
        <select id="filtre-type" v-model="filtreType">
          <option value="">Tous</option>
          <option value="salle">Salle</option>
          <option value="poste">Poste</option>
          <option value="materiel">Matériel</option>
        </select>
  
        <label v-if="filtreType === 'materiel'" for="filtre-sous-type">Type de matériel :</label>
        <select v-if="filtreType === 'materiel'" id="filtre-sous-type" v-model="filtreSousType">
          <option value="">Tous</option>
          <option v-for="type in typesMateriel" :key="type" :value="type">{{ type }}</option>
        </select>
      </div>
  
      <div v-if="equipementsFiltres.length === 0" class="no-equipment">
        Aucun équipement correspondant.
      </div>
  
      <table class="equipement-table" v-else>
        <thead>
          <tr>
            <th>Type</th>
            <th>Nom</th>
            <th>État</th>
            <th>Configuration</th>
            <th>Disponibilité</th>
            <th v-if="isEnseignantOuAdmin">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="e in equipementsFiltres" :key="e.nom + e.type">
            <td>{{ e.type }}</td>
            <td>{{ e.nom }}</td>
            <td>{{ e.etat }}</td>
            <td>{{ e.configuration || '---' }}</td>
            <td>
              <span :class="e.disponible ? 'dispo' : 'indispo'">
                {{ e.disponible ? '✅ Disponible' : '❌ Indisponible' }}
              </span>
            </td>
            <td v-if="isEnseignantOuAdmin">
              <button @click="changerDisponibilite(e)">Changer dispo</button>
              <button @click="changerEtat(e)">Changer état</button>
              <button @click="supprimerEquipement(e)">🗑️ Supprimer</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        equipements: [],
        filtreType: '',
        filtreSousType: '',
        typesMateriel: [
          'ordinateur', 'livre', 'tablette', 'videoprojecteur', 'camera', 'clavier', 'souris'
        ],
        role: ''
      };
    },
    computed: {
      equipementsFiltres() {
        return this.equipements.filter(e => {
          if (!this.filtreType) return true;
  
          if (this.filtreType === 'materiel') {
            if (e.type === 'materiel' || this.typesMateriel.includes(e.type)) {
              if (!this.filtreSousType) return true;
              return e.type === this.filtreSousType;
            }
            return false;
          }
  
          return e.type === this.filtreType;
        });
      },
      isEnseignantOuAdmin() {
        return this.role === 'enseignant' || this.role === 'admin';
      }
    },
    mounted() {
      fetch("http://localhost/ecole_connectee/api/get_equipements.php")
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            this.equipements = data.equipements;
          } else {
            console.error(data.message);
          }
        })
        .catch(err => {
          console.error("Erreur fetch:", err);
        });
  
      const token = localStorage.getItem("token");
      if (token) {
        try {
          const payload = JSON.parse(atob(token.split('.')[1]));
          this.role = payload.role;
        } catch (e) {
          console.error("Erreur décodage token:", e);
        }
      }
    },
    methods: {
        changerDisponibilite(equipement) {
  console.log('Payload envoyé à update_disponibilite.php :', {
    id: equipement.id,
    type: equipement.type,
    disponible: equipement.disponible ? 0 : 1
  });

  fetch("http://localhost/ecole_connectee/api/enseignant/update_disponibilite.php", {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id: equipement.id, type: equipement.type, disponible: equipement.disponible ? 0 : 1 })
  })
  .then(res => res.json())
  .then(data => {
    console.log("Résultat API :", data);
    if (data.success) {
      equipement.disponible = !equipement.disponible;
    } else {
      alert(data.message || "Erreur");
    }
  });
},


      changerEtat(equipement) {
        const nouvelEtat = prompt("Nouveau état (neuf, bon, usé, hors service) :", equipement.etat);
        if (!nouvelEtat) return;
  
        fetch("http://localhost/ecole_connectee/api/enseignant/update_etat.php", {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ id: equipement.id, etat: nouvelEtat })
})

          .then(res => res.json())
          .then(data => {
            if (data.success) {
              equipement.etat = nouvelEtat;
            } else {
              alert(data.message || "Erreur lors de la mise à jour de l'état.");
            }
          });
      },

      supprimerEquipement(equipement) {
  if (!confirm(`Supprimer ${equipement.nom} (${equipement.type}) ?`)) return;

  const token = localStorage.getItem("token");

  fetch("http://localhost/ecole_connectee/api/admin/supprimer_equipement.php", {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
      Authorization: "Bearer " + token
    },
    body: JSON.stringify({ id: equipement.id, type: equipement.type })
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        this.equipements = this.equipements.filter(eq => eq.id !== equipement.id || eq.type !== equipement.type);
        alert("✅ Équipement supprimé");
      } else {
        alert(data.message || "Erreur lors de la suppression.");
      }
    })
    .catch(err => {
      console.error("Erreur suppression:", err);
      alert("❌ Erreur serveur");
    });
},

    }
  };
  </script>
  
  
  <style scoped>
  .equipements-container {
    max-width: 1000px;
    margin: 40px auto;
    padding: 20px;
    font-family: 'Segoe UI', sans-serif;
  }
  
  h2 {
    font-size: 26px;
    margin-bottom: 20px;
    color: #2c3e50;
  }
  
  .filtres {
    display: flex;
    gap: 12px;
    align-items: center;
    background: #eef6fb;
    padding: 12px 16px;
    border-radius: 8px;
    margin-bottom: 20px;
  }
  
  .filtres label {
    font-weight: bold;
    color: #333;
  }
  
  .filtres select {
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
    background-color: white;
    color: #333;
  }
  
  .no-equipment {
    text-align: center;
    font-style: italic;
    color: #777;
  }
  
  .equipement-table {
    width: 100%;
    border-collapse: collapse;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    border-radius: 8px;
    overflow: hidden;
    background: #fff;
  }
  
  .equipement-table th,
  .equipement-table td {
    padding: 12px 16px;
    text-align: left;
    border-bottom: 1px solid #eaeaea;
  }
  
  .equipement-table th {
    background: #f0f4f8;
    color: #333;
  }
  
  .dispo {
    color: green;
    font-weight: bold;
  }
  
  .indispo {
    color: red;
    font-weight: bold;
  }
  </style>
  