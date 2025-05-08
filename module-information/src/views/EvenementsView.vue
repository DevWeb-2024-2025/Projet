<template>
    <div class="filtre-date">
  <label for="date">📅 Filtrer à partir de :</label>
  <input id="date" type="date" v-model="filtreDate" />
</div>

    <div class="evenements-container">
      <h2>📅 Événements à venir</h2>
  
      <div v-if="evenements.length === 0" class="no-event">
        Aucun événement prévu.
      </div>
  
      <div class="event-card" v-for="event in evenementsFiltres" :key="event.id">
        <h3>{{ event.titre }}</h3>
        <p class="date">🗓  {{ formatDate(event.date) }}</p>
        <p class="description">{{ event.description }}</p>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        evenements: [],
        filtreDate: ''
      };
    },

    computed: {
  evenementsFiltres() {
    if (!this.filtreDate) return this.evenements;
    return this.evenements.filter(ev => ev.date >= this.filtreDate);
  }
},


    mounted() {
      fetch("http://localhost/ecole_connectee/api/get_evenements.php")
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            this.evenements = data.evenements;
          } else {
            console.error(data.message);
          }
        })
        .catch(err => {
          console.error("Erreur fetch:", err);
        });
    },
    methods: {
      formatDate(dateStr) {
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(dateStr).toLocaleDateString('fr-FR', options);
      }
    }
  };
  </script>
  
  <style scoped>
  .evenements-container {
    max-width: 900px;
    margin: 40px auto;
    padding: 20px;
    font-family: 'Segoe UI', sans-serif;
  }
  
  h2 {
    font-size: 24px;
    margin-bottom: 25px;
    color: #2c3e50;
  }
  
  .no-event {
    font-style: italic;
    color: #777;
    text-align: center;
    margin-top: 20px;
  }
  
  .event-card {
    background: #f4f9fd;
    border-left: 6px solid #3498db;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 20px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.05);
  }
  
  .event-card h3 {
    margin-bottom: 10px;
    font-size: 20px;
    color: #005a9c;
  }
  
  .event-card .date {
    font-weight: bold;
    margin-bottom: 10px;
    color: #2c3e50;
  }
  
  .event-card .description {
    font-size: 15px;
    color: #333;
  }

  .filtre-date {
  margin-bottom: 20px;
  background: #eef6fc;
  padding: 12px 16px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.filtre-date label {
  font-weight: bold;
  color: #333;
}

.filtre-date input[type="date"] {
  padding: 6px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 14px;
}

  </style>