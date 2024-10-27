<script>
import { fetchUsers, fetchUserById } from '../repository/UserRepository'
import { useRouter } from 'vue-router'

export default {
  data() {
    return {
      email: '',
      password: '',
      errorMessage: '', // Propriété pour stocker le message d'erreur
      users: [], // Propriété pour stocker la liste des utilisateurs
      userDetails: null // Propriété pour stocker les détails de l'utilisateur connecté
    }
  },
  setup() {
    const router = useRouter()
    return { router }
  },
  methods: {
    async onSubmit() {
      try {
        const userId = await this.checkUser(this.password, this.email)
        if (userId) {
          this.errorMessage = '' // Réinitialiser le message d'erreur en cas de succès
          const userDetails = await fetchUserById(userId) // Récupérer les détails de l'utilisateur
          this.userDetails = userDetails // Stocker les détails de l'utilisateur
          this.router.push({ name: 'workingTimes', params: { userId } }) // Rediriger vers WorkingTimes avec l'ID de l'utilisateur
        } else {
          this.errorMessage = 'Invalid email or password' // Définir le message d'erreur
        }
      } catch (error) {
        console.error('Error during login:', error)
        this.errorMessage = 'An error occurred. Please try again.' // Définir le message d'erreur en cas d'exception
      }
    },
    async checkUser(password, email) {
      try {
        const users = await fetchUsers()
        this.users = users // Stocker les utilisateurs récupérés pour affichage
        const user = users.find((user) => user.password === password && user.email === email)
        return user ? user.id : null // Retourne l'ID de l'utilisateur si trouvé, sinon null
      } catch (error) {
        console.error('Failed to check user:', error)
        return null
      }
    }
  }
}
</script>

<template>
  <div class="container mt-5">
    <form class="form" @submit.prevent="onSubmit">
      <div class="text-center">
        <h1>Login</h1>
      </div>
      <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
      <!-- Div pour afficher le message d'erreur -->
      <div class="form-group">
        <label for="exampleInputEmail1">Email address</label>
        <input
          type="email"
          class="form-control"
          id="exampleInputEmail1"
          v-model="email"
          aria-describedby="emailHelp"
          placeholder="Enter email"
          required
        />
        <small id="emailHelp"> We'll never share your email with anyone else. </small>
      </div>
      <div class="form-group">
        <label for="exampleInputPassword">Password</label>
        <input
          type="password"
          class="form-control"
          id="exampleInputPassword"
          v-model="password"
          placeholder="Enter password"
          required
        />
      </div>
      <div class="mt-4 text-end">
        <button type="submit" class="btn btn-primary">Login</button>
      </div>
    </form>

    <!-- Liste pour afficher les utilisateurs -->
    <div v-if="userDetails">
      <h3>User Details</h3>
      <p>ID: {{ userDetails.id }}</p>
      <p>Username: {{ userDetails.username }}</p>
      <p>Email: {{ userDetails.email }}</p>
      <!-- Afficher d'autres détails de l'utilisateur ici -->
    </div>
  </div>
</template>

<style>
.container {
  width: 100%;
  display: flex;
  justify-content: center;
  color: white;
}
.form {
  width: 50%;
  background-color: #484848;
  padding: 5%;
  border-radius: 15px;
}
.alert-danger {
  color: red;
}
@media (max-width: 800px) {
  .form {
    width: 100%; /* 100% de la largeur pour les écrans de moins de 800 pixels */
  }
}
small {
  color: white; /* Couleur du texte pour les éléments de texte */
}
</style>
