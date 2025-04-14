// src/auth.js
import { ref } from 'vue';

export const isAuthenticated = ref(!!localStorage.getItem("token"));

export function login(token) {
  localStorage.setItem("token", token);
  isAuthenticated.value = true;
}

export function logout() {
  localStorage.removeItem("token");
  isAuthenticated.value = false;
}