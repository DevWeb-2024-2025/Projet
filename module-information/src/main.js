import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import './style.css';

// ✅ Redirection auto si utilisateur déjà connecté
const token = localStorage.getItem('token');
if (token && window.location.pathname === '/login') {
  window.location.href = '/profil';
}



createApp(App).use(router).mount('#app');

