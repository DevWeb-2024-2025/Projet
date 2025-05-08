<template>
  <div class="profile-container">
    <div class="profile-card">
      <img class="avatar" src="/src/assets/default-avatar.png" alt="Avatar">
      <div class="user-info">
        <h2 class="welcome-text">Bienvenue {{ prenom }} {{ nom }}</h2>
        <p class="points">{{ points }} points</p>
        <div class="progress-bar">
          <div class="progress" :style="{ width: niveauProgression + '%' }"></div>
        </div>
        <p class="level">Niveau : <span>{{ niveau }}</span></p>
      </div>
    </div>

    <div class="message-box">
      <h3>✉️ Envoyer un message</h3>
      <form @submit.prevent="envoyerNotification">
        <label>Email du destinataire :</label>
        <input type="email" v-model="form.email" required />

        <label>Message :</label>
        <textarea v-model="form.message" required rows="3"></textarea>

        <button type="submit">Envoyer</button>
      </form>
    </div>

    <div class="history-section">
      <h3>📋 Historique des réservations</h3>
      <ul class="reservation-list">
        <li v-for="res in reservations" :key="res.id">
          <span class="icon">🗓️</span>
          {{ formatDateTime(res.date_debut) }} - {{ formatDateTime(res.date_fin) }}
          <span class="type"> ({{ res.type }})</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      nom: '',
      prenom: '',
      points: 0,
      reservations: [],
      form: {
        email: '',
        message: ''
      }
    };
  },
  computed: {
    niveau() {
      if (this.points >= 200) return "Expert";
      if (this.points >= 100) return "Confirmé";
      if (this.points >= 50) return "Intermediaire";
      return "Débutant";
    },
    niveauProgression() {
      return Math.min((this.points % 50) * 2, 100);
    }
  },
  mounted() {
    const token = localStorage.getItem("token");
    if (!token) {
      this.$router.push("/login");
      return;
    }

    fetch("http://localhost/ecole_connectee/api/etudiant/get_profil.php", {
      headers: {
        Authorization: "Bearer " + token
      }
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          this.nom = data.nom;
          this.prenom = data.prenom;
          this.points = data.points;
          this.reservations = data.reservations;
        } else {
          console.error(data.message);
        }
      })
      .catch(err => console.error("Erreur API profil :", err));
  },
  methods: {
    formatDateTime(dateStr) {
      const options = {
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
        hour: '2-digit', minute: '2-digit'
      };
      return new Date(dateStr).toLocaleDateString('fr-FR', options);
    },
    envoyerNotification() {
      const token = localStorage.getItem("token");
      fetch("http://localhost/ecole_connectee/api/etudiant/send_notification.php", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + token
        },
        body: JSON.stringify(this.form)
      })
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            alert("✅ Message envoyé !");
            this.form.email = '';
            this.form.message = '';
          } else {
            alert(data.message || "Erreur lors de l'envoi");
          }
        })
        .catch(err => {
          console.error("Erreur envoi:", err);
          alert("Erreur de connexion");
        });
    }
  }
};
</script>

<style scoped>
.profile-container {
  max-width: 800px;
  margin: 40px auto;
  padding: 20px;
  font-family: 'Segoe UI', sans-serif;
}

.profile-card {
  background: linear-gradient(135deg, #ffffff, #f4f7fb);
  border-radius: 20px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  display: flex;
  padding: 30px;
  align-items: center;
  transition: all 0.3s ease-in-out;
}

.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  border: 4px solid #e0e0e0;
  margin-right: 25px;
}

.user-info {
  flex: 1;
}

.welcome-text {
  font-size: 26px;
  font-weight: 700;
  color: #333;
  margin-bottom: 10px;
}

.points {
  font-weight: bold;
  font-size: 18px;
  color: #2e7d32;
}

.progress-bar {
  background: #e0e0e0;
  height: 12px;
  border-radius: 8px;
  margin: 10px 0;
  overflow: hidden;
}

.progress {
  height: 100%;
  background: linear-gradient(to right, #4caf50, #81c784);
  width: 0;
  border-radius: 8px;
  transition: width 0.6s ease;
}

.level {
  font-size: 14px;
  font-style: italic;
  color: #555;
}

.level span {
  font-weight: 600;
  color: #000;
}

.message-box {
  background: #fff;
  margin-top: 30px;
  padding: 20px 30px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.message-box h3 {
  font-size: 18px;
  margin-bottom: 15px;
  color: #333;
}

.message-box input,
.message-box textarea {
  width: 100%;
  padding: 10px;
  margin: 6px 0 16px;
  border-radius: 8px;
  border: 1px solid #ccc;
  font-size: 15px;
}

.message-box button {
  background: #4caf50;
  border: none;
  color: white;
  padding: 10px 16px;
  font-size: 15px;
  border-radius: 8px;
  cursor: pointer;
}

.message-box button:hover {
  background: #388e3c;
}

.history-section {
  margin-top: 40px;
  background: #fff;
  padding: 20px 30px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.history-section h3 {
  margin-bottom: 20px;
  font-size: 20px;
  color: #333;
}

.reservation-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.reservation-list li {
  padding: 12px 0;
  border-bottom: 1px solid #eaeaea;
  font-size: 16px;
  color: #333;
  display: flex;
  align-items: center;
}

.icon {
  margin-right: 8px;
  font-size: 18px;
}

.type {
  font-weight: bold;
  color: #1565c0;
  margin-left: 5px;
}
</style>
