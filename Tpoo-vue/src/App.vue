<script setup>
import { ref, onMounted } from 'vue'
import { RouterView } from 'vue-router'
import { fetchUserById } from './repository/UserRepository'
import Navbar from './components/Navbar.vue'

const connectedUser = ref({ username: '', email: '' })

onMounted(async () => {
  // const loggedInUserId = '1' // Remplacez par l'ID réel de l'utilisateur connecté
  // try {
  //   const user = await fetchUserById(loggedInUserId) // Récupération de l'utilisateur

  //   // Vérification que l'utilisateur existe et qu'il a bien les propriétés attendues
  //   if (user && user.data) {
  //     connectedUser.value = {
  //       username: user.data.username,
  //       email: user.data.email
  //     } // Mise à jour des données
  //     console.log('Utilisateur récupéré :', connectedUser.value)
  //   } else {
  //     console.warn('Aucun utilisateur trouvé ou données incomplètes.')
  //   }
  // } catch (error) {
  //   console.error("Erreur lors de la récupération de l'utilisateur :", error)
  // }
})
</script>

<template>
  <header>
    <Navbar> </Navbar>
  </header>
  <RouterView />
</template>

<style scoped>
header {
  line-height: 1.5;
  max-height: 100vh;
}

nav {
  width: 100%;
  display: flex;
  justify-content: space-between;
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid;
}

nav a:first-of-type {
  border: 0;
}
@media (min-width: 1024px) {
  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
}
</style>
