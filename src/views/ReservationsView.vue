<template>
  <div class="reservations">
    <div class="header">
      <h2>Vos réservations</h2>
    </div>

    <div v-if="reservations.length === 0" class="no-data">
      😕 Aucune réservation trouvée.
    </div>

    <transition-group name="fade" tag="ul" class="reservation-list">
      <li
        v-for="res in reservations"
        :key="res.id"
        class="reservation-card"
      >
        <div class="type-icon">
          <span v-if="res.type === 'salle'">🪑</span>
          <span v-else-if="res.type === 'poste'">💻</span>
          <span v-else-if="res.type === 'materiel'">📦</span>
          <span v-else>🔖</span>
        </div>
        <div class="details">
          <strong class="title text-capitalize">{{ res.type }}</strong>
          <p>
            Du <strong>{{ formatDate(res.date_debut) }}</strong><br />
            au <strong>{{ formatDate(res.date_fin) }}</strong>
          </p>
        </div>
      </li>
    </transition-group>
  </div>
</template>

<script>
export default {
  data() {
    return {
      reservations: [],
    };
  },
  async mounted() {
    const token = localStorage.getItem("token");
    if (!token) {
      alert("Vous devez être connecté.");
      this.$router.push("/login");
      return;
    }

    try {
      const res = await fetch(
        "http://localhost/ecole_connectee/api/etudiant/get_reservations.php",
        {
          method: "GET",
          headers: {
            Authorization: "Bearer " + token,
          },
        }
      );

      const data = await res.json();
      if (data.success) {
        this.reservations = data.reservations;
      } else {
        alert(data.message || "Erreur lors du chargement.");
      }
    } catch (err) {
      console.error(err);
      alert("Erreur de connexion au serveur.");
    }
  },
  methods: {
    formatDate(datetimeStr) {
      const date = new Date(datetimeStr);
      return date.toLocaleString("fr-FR", {
        weekday: "long",
        year: "numeric",
        month: "long",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        hour12: false,
      });
    }
  }
};
</script>

<style scoped>
.reservations {
  padding: 30px;
  max-width: 800px;
  margin: auto;
  background: #fefefe;
}

.header {
  text-align: center;
  margin-bottom: 30px;
}

.no-data {
  text-align: center;
  font-size: 18px;
  color: #888;
  margin-top: 40px;
}

.reservation-list {
  list-style: none;
  padding: 0;
  display: grid;
  gap: 16px;
}

.reservation-card {
  display: flex;
  align-items: flex-start;
  padding: 20px;
  border-radius: 14px;
  background: white;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06);
  transition: transform 0.2s ease;
}

.reservation-card:hover {
  transform: scale(1.01);
}

.type-icon {
  font-size: 28px;
  margin-right: 15px;
}

.details {
  text-align: left;
}

.title {
  font-size: 18px;
  margin-bottom: 6px;
  display: block;
  color: #333;
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.text-capitalize {
  text-transform: capitalize;
}
</style>