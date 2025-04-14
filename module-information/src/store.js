import { reactive } from 'vue';

export const store = reactive({
  isLoggedIn: !!localStorage.getItem('token'),

  login(token) {
    localStorage.setItem('token', token);
    this.isLoggedIn = true;
  },

  logout() {
    localStorage.removeItem('token');
    this.isLoggedIn = false;
  }
});
