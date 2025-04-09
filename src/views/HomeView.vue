<template>
  <div class="container">
    <!-- Présentation -->
    <section class="welcome">
      <h1>Bienvenue sur <span class="brand">ConnectTech School</span></h1>
      <p>
        Explorez notre établissement, découvrez nos équipements et restez informé des événements à venir.
        Réservez vos espaces facilement grâce à cette plateforme.
      </p>
      <img :src="image" alt="Image école" />
    </section>

    <!-- Carrousel d'événements -->
    <section class="carousel">
      <h2>📅 Événements à venir</h2>
      <div class="slider">
        <div class="slide" v-for="event in events" :key="event.id">
          <h3>{{ event.titre }}</h3>
          <p><strong>{{ event.date }}</strong></p>
          <p>{{ event.description }}</p>
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
  max-width: 1100px;
  margin: 40px auto;
  padding: 2rem;
  background-color: #f0f4f8;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.05);
}

section {
  margin-bottom: 3rem;
  background-color: #ffffff;
  padding: 2rem;
  border-radius: 14px;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.04);
}

h1 {
  font-size: 2.2rem;
  margin-bottom: 1rem;
  color: #1a1a1a;
}

.brand {
  color: #007acc;
  font-weight: 700;
}

p {
  font-size: 1.1rem;
  color: #333;
  line-height: 1.6;
  margin-bottom: 1rem;
}

img {
  width: 100%;
  max-height: 350px;
  object-fit: cover;
  border-radius: 12px;
  margin-top: 1rem;
  box-shadow: 0 8px 20px rgba(0,0,0,0.1);
}

.carousel h2 {
  font-size: 1.8rem;
  margin-bottom: 1rem;
  color: #333;
}

.slider {
  display: flex;
  overflow-x: auto;
  gap: 20px;
  scroll-snap-type: x mandatory;
  padding-bottom: 0.5rem;
}

.slide {
  flex: 0 0 auto;
  scroll-snap-align: start;
  min-width: 280px;
  background-color: #e6f0fa;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 10px rgba(0,0,0,0.05);
}

.slide h3 {
  font-size: 1.3rem;
  color: #005b99;
  margin-bottom: 0.5rem;
}

.slide p {
  font-size: 1rem;
  color: #222;
  margin: 0.2rem 0;
}
</style>