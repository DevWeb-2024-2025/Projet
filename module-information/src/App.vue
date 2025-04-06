<template>
  <nav style="display: flex; gap: 1rem; align-items: center; justify-content: flex-end; margin-bottom: 20px;">
    <router-link to="/">🏠 Accueil</router-link>
    <router-link to="/search">🔍 Recherche</router-link>
    
    <router-link to="/login">
      <button>Se connecter</button>
    </router-link>

    <router-link to="/register">
      <button>S’inscrire</button>
    </router-link>
  </nav>

  <router-view />
</template>

<style scoped>
button {
  background-color: #2563eb;
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  font-weight: bold;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #1e40af;
}
</style>


<script>
export default {
  name: "App"
}
</script>
