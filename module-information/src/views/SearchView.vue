<template>
  <div class="container">
    <h1>🔍 Recherche de Salles</h1>

    <!-- Formulaire -->
    <form @submit.prevent="lancerRecherche" class="search-form">
      <label for="type">Type de salle :</label>
      <select v-model="type" id="type">
        <option disabled value="">Choisir un type</option>
        <option value="cours">Cours</option>
        <option value="labo">Labo</option>
        <option value="amphi">Amphithéâtre</option>
      </select>

      <label for="date">Date :</label>
      <input type="date" v-model="date" id="date" />

      <button type="submit">Rechercher</button>
    </form>

    <!-- Résultats -->
    <div class="results">
      <div v-for="salle in resultats" :key="salle.id" class="card">
        <h3>{{ salle.nom }}</h3>
        <p>Type : {{ salle.type }}</p>
        <p>Capacité : {{ salle.capacite }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "SearchView",
  data() {
    return {
      type: '',
      date: '',
      resultats: []
    };
  },
  methods: {
    lancerRecherche() {
      console.log("Recherche lancée avec :", this.type, this.date);

      fetch(`http://localhost:3000/salles-disponibles?type=${this.type}&date=${this.date}`)
        .then(res => res.json())
        .then(data => {
          console.log("Résultats reçus :", data);
          this.resultats = data;
        })
        .catch(err => {
          console.error("Erreur fetch :", err);
        });
    }
  }
};
</script>
