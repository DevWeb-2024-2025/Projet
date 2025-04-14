<template>
  <div class="login">
    <h2>Connexion</h2>
    <input type="email" v-model="email" placeholder="Email" />
    <input type="password" v-model="password" placeholder="Mot de passe" />
    <button @click="loginUser">Se connecter</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { store } from '../store.js';

const email = ref('');
const password = ref('');
const router = useRouter();

async function loginUser() {
  try {
    const response = await fetch("http://localhost/ecole_connectee/api/auth/login.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        email: email.value,
        password: password.value
      })
    });

    const data = await response.json();

    if (data.success) {
      store.login(data.token);
      router.push("/profil");
    } else {
      alert(data.message || "Identifiants incorrects.");
    }
  } catch (err) {
    console.error(err);
    alert("Erreur de connexion au serveur.");
  }
}
</script>

<style scoped>
.login {
  max-width: 400px;
  margin: 80px auto;
  padding: 30px;
  background-color: #f1f4f8;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  text-align: center;
}

input {
  display: block;
  margin: 15px auto;
  padding: 10px;
  width: 90%;
  border-radius: 6px;
  border: 1px solid #ccc;
  font-size: 16px;
}

button {
  background-color: #111;
  color: white;
  border: none;
  padding: 10px 20px;
  font-size: 16px;
  margin-top: 10px;
  border-radius: 6px;
  cursor: pointer;
}

button:hover {
  background-color: #333;
}
</style>