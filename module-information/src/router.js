// src/router.js
import { createRouter, createWebHistory } from 'vue-router';
import HomeView from './views/HomeView.vue';
// import SearchView from './views/SearchView.vue';
// import AuthView from './views/AuthView.vue' ;
import LoginView from './views/LoginView.vue';
import RegisterView from './views/RegisterView.vue';
import ReservationsView from './views/ReservationsView.vue';
import AddReservationView from './views/AddReservationView.vue';
import ProfilView from './views/ProfilView.vue';
import ReservationEnCoursView from './views/ReservationEnCoursView.vue';
import EvenementsView from './views/EvenementsView.vue';
import EquipementsView from './views/EquipementsView.vue';
import NotificationsView from './views/NotificationsView.vue';
import AjouterMaterielView from './views/AjouterMaterielView.vue';
import AdminView from './views/AdminView.vue';









const routes = [
  { path: '/', component: HomeView },
//  { path: '/search', component: SearchView },
//  {path: '/auth', component: AuthView },
  { path: '/login', component: LoginView },
  { path: '/register', component: RegisterView },
  { path: '/reservations', component: ReservationsView}, 
  {
    path: '/ajouter-reservation',
    name: 'AddReservation',
    component: AddReservationView
  },
  {
    path: '/profil',
    name: 'Profil',
    component: ProfilView
  },
  {
    path: '/reservations-en-cours',
    name: 'ReservationsEnCours',
    component: ReservationEnCoursView
  },

  {
    path: '/evenements',
    name: 'Evenements',
    component: EvenementsView
  },

  {
    path: '/equipements',
    name: 'Equipements',
    component: EquipementsView
  },
  {
    path: '/notifications',
    name: 'Notifications',
    component: NotificationsView
  },
  {
    path: '/ajouter-materiel',
    name: 'AjouterMateriel',
    component: AjouterMaterielView
  },
  { path: '/admin', name: 'Admin', component: AdminView },

  
  
  
  
  
  
  
  
  
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
