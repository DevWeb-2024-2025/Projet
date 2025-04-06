<template>
  <div class="container">
    <!-- Présentation -->
    <section>
      <h1>Bienvenue sur ConnectTech School</h1>
      <p>
        Cette plateforme permet aux visiteurs de découvrir l'établissement, ses équipements,
        et les événements à venir. Réservez une salle ou explorez nos ressources librement.
      </p>
      <img :src="image" alt="Image école" style="width: 50%; max-height: 300px; object-fit: cover; border-radius: 10px;" />
    </section>

    <!-- Carrousel / Slider -->
    <section style="margin-top: 40px;">
      <h2>📅 Événements à venir</h2>
      <div class="slider">
        <div class="slide" v-for="event in events" :key="event.id">
          <h3>{{ event.titre }}</h3>
          <p>{{ event.date }} - {{ event.description }}</p>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import imageEcole from '../assets/ConnecTechSchool.png';

export default {
  name: 'HomeView',
  data() {
    return {
      image: imageEcole,
      events: [
        { id: 1, titre: "Portes ouvertes", date: "15 avril", description: "Venez découvrir nos formations." },
        { id: 2, titre: "Hackathon", date: "20 avril", description: "Concours de code et d'innovation." },
        { id: 3, titre: "Conférence IA", date: "25 avril", description: "Intervenants spécialisés en intelligence artificielle." }
      ]
    };
  }
};
</script>


<style scoped>
.container {
  padding: 2rem;
  max-width: 1100px;
  margin: 0 auto;
  text-align: left;
  background-color: #e5edf5;
  border-radius: 12px;
}

section {
  margin-bottom: 3rem;
  background-color: #d1e3f0;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

h1 {
  font-size: 2.5rem;
  color: #1f2937;
  margin-bottom: 0.5rem;
}

p {
  font-size: 1.1rem;
  color: #374151;
  margin-bottom: 1rem;
}

img {
  width: 100%;
  border-radius: 12px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.08);
}

.slider {
  display: flex;
  overflow-x: auto;
  gap: 20px;
  scroll-snap-type: x mandatory;
  padding-bottom: 1rem;
}

.slide {
  flex: 0 0 auto;
  background-color: #c7dbeb;
  padding: 1.5rem;
  border-radius: 12px;
  min-width: 280px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  scroll-snap-align: start;
}

.slide h3 {
  font-size: 1.4rem;
  margin-bottom: 0.5rem;
  color: #1f2937;
}

.slide p {
  font-size: 1rem;
  color: #374151;
}

button {
  background-color: #2563eb;
  color: white;
  padding: 0.6rem 1.2rem;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #1e40af;
}


</style>


