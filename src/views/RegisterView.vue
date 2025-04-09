<template>
  <div class="register-container">
    <div class="register-card">
      <h2>Créer un compte</h2>

      <form @submit.prevent="register">
        <input v-model="form.nom" placeholder="Nom" required />
        <input v-model="form.prenom" placeholder="Prénom" required />
        <input v-model="form.email" type="email" placeholder="Email" required />
        <input v-model="form.password" type="password" placeholder="Mot de passe" required />
        <button type="submit">S'inscrire</button>
      </form>

      <!-- ✅ Message de succès ou erreur -->
      <p v-if="message" :class="messageClass">{{ message }}</p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        nom: '',
        prenom: '',
        email: '',
        password: ''
      },
      message: '',
      messageType: '' // 'success' ou 'error'
    };
  },
  computed: {
    messageClass() {
      return {
        success: this.messageType === 'success',
        error: this.messageType === 'error'
      };
    }
  },
  methods: {
    async register() {
      try {
        const res = await fetch('http://localhost/ecole_connectee/api/auth/register.php', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(this.form)
        });

        const text = await res.text();

        try {
          const data = JSON.parse(text);

          if (data.success) {
            this.message = "Inscription réussie !";
            this.messageType = "success";
            setTimeout(() => {
              this.$router.push('/login');
            }, 1500); // redirection après 1.5s
          } else {
            this.message = data.message || "Erreur lors de l'inscription";
            this.messageType = "error";
          }

        } catch (e) {
          console.error("Réponse non JSON :", text);
          this.message = "Réponse invalide du serveur.";
          this.messageType = "error";
        }

      } catch (err) {
        console.error("Erreur réseau :", err);
        this.message = "Erreur de connexion au serveur.";
        this.messageType = "error";
      }
    }
  }
};
</script>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 90vh;
  background-color: #f3f6fa;
}

.register-card {
  background-color: white;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
  width: 100%;
  max-width: 400px;
  text-align: center;
}

h2 {
  margin-bottom: 20px;
  color: #1f1f1f;
}

form {
  display: flex;
  flex-direction: column;
}

input {
  padding: 12px;
  margin-bottom: 16px;
  border-radius: 6px;
  border: 1px solid #ccc;
  font-size: 15px;
  background-color: #fefefe;
  color: #000; /* ✅ ICI : Texte noir */
}

input:focus {
  outline: none;
  border-color: #080808;
}

button {
  background-color: #111111;
  color: white;
  padding: 12px;
  font-size: 16px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

button:hover {
  background-color: #0056b3;
}

/* ✅ Style des messages */
.success {
  color: #2e7d32;
  margin-top: 15px;
  font-weight: bold;
}

.error {
  color: #d32f2f;
  margin-top: 15px;
  font-weight: bold;
}
</style>