// src/store/store.js
import { createStore } from 'vuex'; // Modifie cette ligne

const store = createStore({ // Change `new Vuex.Store` par `createStore`
  state: {
    isAuthenticated: true,
    isManager: false,
    isAdmin: true,
  },
  mutations: {
    login(state, roles) {
      state.isAuthenticated = true;
      state.isManager = roles.isManager;
      state.isAdmin = roles.isAdmin;
    },
    logout(state) {
      state.isAuthenticated = false;
      state.isManager = false;
      state.isAdmin = false;
    },
  },
});

export default store;
