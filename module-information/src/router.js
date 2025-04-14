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
  }
  
  
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
