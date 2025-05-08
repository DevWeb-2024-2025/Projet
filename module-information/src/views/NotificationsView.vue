<template>
    <div class="notifications-container">
      <h2>📬 Mes notifications</h2>
  
      <div v-if="notifications.length === 0" class="no-notification">
        Aucune notification pour le moment.
      </div>
  
      <ul class="notification-list">
        <li v-for="notif in notifications" :key="notif.id" class="notification-item">
            <p class="expediteur">
  ✉️ De : {{ notif.expediteur_prenom }} {{ notif.expediteur_nom }} ({{ notif.expediteur_email }})
</p>
          <p class="message">{{ notif.message }}</p>
          <p class="date">Reçu le {{ formatDate(notif.date_envoi) }}</p>
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        notifications: []
      };
    },
    mounted() {
      const token = localStorage.getItem("token");
      if (!token) return;
  
      fetch("http://localhost/ecole_connectee/api/etudiant/get_notifications.php", {
        headers: {
          Authorization: "Bearer " + token
        }
      })
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            this.notifications = data.notifications;
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
        const options = {
          weekday: "short",
          year: "numeric",
          month: "short",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit"
        };
        return new Date(dateStr).toLocaleDateString("fr-FR", options);
      }
    }
  };
  </script>
  
  <style scoped>
  .notifications-container {
    max-width: 800px;
    margin: 40px auto;
    padding: 20px;
    font-family: 'Segoe UI', sans-serif;
  }
  
  h2 {
    font-size: 24px;
    margin-bottom: 20px;
    color: #2c3e50;
  }
  
  .no-notification {
    text-align: center;
    font-style: italic;
    color: #777;
  }
  
  .notification-list {
    list-style: none;
    padding: 0;
  }
  
  .notification-item {
    background: #f4f9ff;
    border-left: 5px solid #3498db;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 15px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.05);
  }
  
  .message {
    font-size: 16px;
    margin-bottom: 6px;
    color: #333;
  }
  
  .date {
    font-size: 13px;
    color: #666;
    font-style: italic;
  }

  .expediteur {
  font-size: 14px;
  font-weight: bold;
  color: #2c3e50;
  margin-bottom: 6px;
}

  </style>
  