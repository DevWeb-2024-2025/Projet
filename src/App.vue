<template>
  <div id="app">
    <nav class="navbar">
      <router-link to="/" class="nav-link">Accueil</router-link>
      <div class="separator"></div>

      <router-link to="/search" class="nav-link">Recherche</router-link>
      <div class="separator"></div>

      <router-link to="/profil" v-if="isAuthenticated" class="nav-link">Profil</router-link>
      <div class="separator"></div>
      <router-link to="/ajouter-reservation" v-if="isAuthenticated" class="nav-link">Ajouter</router-link>
      <div class="separator"></div>
      <router-link to="/reservations" v-if="isAuthenticated" class="nav-link">Mes réservations</router-link>

      <div class="spacer"></div>

      <router-link to="/login" v-if="!isAuthenticated" class="login-btn">Se connecter</router-link>
      <router-link to="/register" v-if="!isAuthenticated" class="register-btn">S'inscrire</router-link>
      <button @click="logout" v-if="isAuthenticated" class="logout-btn">Se déconnecter</button>
    </nav>

    <router-view />
  </div>
</template>

<script>
export default {
  computed: {
    isAuthenticated() {
      return !!localStorage.getItem("token");
    }
  },
  methods: {
    logout() {
      localStorage.removeItem("token");
      this.$router.push("/login");
    }
  }
};
</script>

<style scoped>
/* NAVBAR */
.navbar {
  background-color: #111;
  padding: 10px 20px;
  display: flex;
  align-items: center;
  font-family: Arial, sans-serif;
}

/* Links */
.nav-link {
  color: white;
  text-decoration: none;
  font-weight: bold;
  margin: 0 8px;
  transition: background-color 0.2s ease;
  padding: 6px 10px;
}

.nav-link:hover {
  background-color: #222;
  border-radius: 4px;
}

/* Separator */
.separator {
  width: 1px;
  height: 20px;
  background-color: white;
  opacity: 0.4;
}

/* Spacer to push auth buttons to right */
.spacer {
  flex-grow: 1;
}

/* Auth Buttons */
.login-btn,
.register-btn,
.logout-btn {
  background-color: transparent;
  border: none;
  color: white;
  font-weight: bold;
  margin-left: 15px;
  cursor: pointer;
  padding: 6px 10px;
}

.logout-btn {
  background-color: #dc3545;
  border-radius: 4px;
}

.logout-btn:hover {
  background-color: #c82333;
}
</style>