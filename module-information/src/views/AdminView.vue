<template>
    <div class="admin-container">
      <h2>🔐 Panneau d'administration</h2>
  
      <section>
        <h3>👥 Gestion des utilisateurs</h3>
  
        <form @submit.prevent="ajouterUtilisateur" class="add-user-form">
          <input v-model="newUser.nom" placeholder="Nom" required />
          <input v-model="newUser.prenom" placeholder="Prénom" required />
          <input v-model="newUser.email" type="email" placeholder="Email" required />
          <input v-model="newUser.password" type="password" placeholder="Mot de passe" required />
          <select v-model="newUser.role" required>
            <option disabled value="">Rôle</option>
            <option value="etudiant">Etudiant</option>
            <option value="enseignant">Enseignant</option>
            <option value="admin">Admin</option>
          </select>
          <button type="submit">Ajouter utilisateur</button>
        </form>
  
        <table class="admin-table">
          <thead>
            <tr>
              <th>Nom</th>
              <th>Prénom</th>
              <th>Email</th>
              <th>Rôle</th>
              <th>Points</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="u in utilisateurs" :key="u.id">
              <td>{{ u.nom }}</td>
              <td>{{ u.prenom }}</td>
              <td>{{ u.email }}</td>
              <td>{{ u.role }}</td>
              <td>
                <input v-model.number="u.points" type="number" style="width: 60px" />
                <button @click="modifierPoints(u.id, u.points)">📂</button>
              </td>
              <td><button @click="supprimerUtilisateur(u.id)">🗑 Supprimer</button></td>
            </tr>
          </tbody>
        </table>
      </section>
  
      <section>
        <h3>🧰 Gestion des équipements</h3>
        <table class="admin-table">
          <thead>
            <tr>
              <th>Type</th>
              <th>Nom</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="e in equipements" :key="e.type + e.id">
              <td>{{ e.type }}</td>
              <td>{{ e.nom }}</td>
              <td><button @click="supprimerEquipement(e.id, e.type)">🗑 Supprimer</button></td>
            </tr>
          </tbody>
        </table>
      </section>
    </div>
</template>

<script>
export default {
  data() {
    return {
      utilisateurs: [],
      equipements: [],
      newUser: {
        nom: '', prenom: '', email: '', password: '', role: ''
      }
    };
  },
  mounted() {
    this.fetchUtilisateurs();
    this.fetchEquipements();
  },
  methods: {
    async fetchUtilisateurs() {
      const token = localStorage.getItem("token");
      const res = await fetch("http://localhost/ecole_connectee/api/admin/get_utilisateurs.php", {
        headers: {
          Authorization: "Bearer " + token
        }
      });
      const data = await res.json();
      if (data.success) this.utilisateurs = data.utilisateurs;
    },
    async fetchEquipements() {
      const res = await fetch("http://localhost/ecole_connectee/api/get_equipements.php");
      const data = await res.json();
      if (data.success) this.equipements = data.equipements;
    },
    async ajouterUtilisateur() {
      const res = await fetch("http://localhost/ecole_connectee/api/admin/ajouter_utilisateur.php", {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(this.newUser)
      });
      const data = await res.json();
      if (data.success) {
        this.fetchUtilisateurs();
        this.newUser = { nom: '', prenom: '', email: '', password: '', role: '' };
      }
    },
    async modifierPoints(id, points) {
      const token = localStorage.getItem("token");
      await fetch("http://localhost/ecole_connectee/api/admin/update_points.php", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: "Bearer " + token
        },
        body: JSON.stringify({ id, points })
      });
    },
    async supprimerUtilisateur(id) {
      const token = localStorage.getItem("token");
      await fetch("http://localhost/ecole_connectee/api/admin/supprimer_utilisateur.php", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: "Bearer " + token
        },
        body: JSON.stringify({ id })
      });
      this.fetchUtilisateurs();
    },
    async supprimerEquipement(id, type) {
      const token = localStorage.getItem("token");
      await fetch("http://localhost/ecole_connectee/api/admin/supprimer_equipement.php", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: "Bearer " + token
        },
        body: JSON.stringify({ id, type })
      });
      this.fetchEquipements();
    }
  }
}
</script>

<style scoped>
.admin-container {
  max-width: 1100px;
  margin: auto;
  padding: 30px;
  font-family: 'Segoe UI', sans-serif;
}

.admin-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}
.admin-table th,
.admin-table td {
  padding: 10px;
  border: 1px solid #ddd;
}
.admin-table th {
  background: #f0f0f0;
}

.add-user-form {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 20px;
}

.add-user-form input,
.add-user-form select {
  padding: 8px;
  border-radius: 6px;
  border: 1px solid #ccc;
}
</style>
