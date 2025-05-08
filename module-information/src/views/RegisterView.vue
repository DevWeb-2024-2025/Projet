<template>
  <div class="register-container">
    <div class="register-card">
      <h2>Créer un compte</h2>

      <form @submit.prevent="register">
        <input v-model="form.nom" placeholder="Nom" required />
        <input v-model="form.prenom" placeholder="Prénom" required />
        <input v-model="form.email" type="email" placeholder="Email" required />
        <input v-model="form.password" type="password" placeholder="Mot de passe" required />

        <!-- ✅ Choix du rôle -->
        <select v-model="form.role" required>
          <option disabled value="">-- Choisir un rôle --</option>
          <option value="etudiant">Étudiant</option>
          <option value="enseignant">Enseignant</option>
          <option value="admin">Admin</option>
        </select>

        <button type="submit">S'inscrire</button>
      </form>

      <p v-if="message" :class="messageType">{{ message }}</p>
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
        password: '',
        role: ''
      },
      message: '',
      messageType: ''
    };
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

        const data = await res.json();
        if (data.success) {
          this.message = "✅ Compte créé avec succès.";
          this.messageType = "success";
          setTimeout(() => {
            this.$router.push('/login');
          }, 1500);
        } else {
          this.message = data.message || "Erreur lors de l'inscription.";
          this.messageType = "error";
        }
      } catch (err) {
        console.error(err);
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

input, select {
  display: block;
  width: 100%;
  padding: 12px;
  margin-bottom: 16px;
  border-radius: 6px;
  border: 1px solid #ccc;
  font-size: 15px;
}

button {
  background-color: #111111;
  color: white;
  padding: 12px;
  font-size: 16px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}

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
