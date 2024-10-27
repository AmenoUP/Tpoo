<template>
  <div class="mt-2 text-center">
    <h1>Dashboard</h1>
  </div>
  <div class="User m-2">
    <input class="form-control custom-width" v-model="prefix" placeholder="Recherche" />
    <div class="user-management">
      <!-- Colonne 1 : Tableau des utilisateurs -->
      <div class="user-table">
        <table class="table table-dark table-striped table-hover m-0">
          <thead>
            <tr class="text-center">
              <th>Username</th>
              <th>Email</th>
              <th>Password</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody class="tbody">
            <tr v-for="user in filteredUsers" :key="user.id">
              <td>{{ user.username }}</td>
              <td>{{ user.email }}</td>
              <td>{{ user.password }}</td>
              <td>{{ getRole(user) }}</td>
              <td>
                <!-- Bouton "Modifier" avec l'icône de crayon -->
                <button class="btn custom-edit-btn" @click="openModal(user)">
                  <i class="bi bi-pencil-fill"></i>
                </button>

                <!-- Bouton "Supprimer" avec l'icône de poubelle -->
                <button class="btn custom-delete-btn" @click="() => del(user.id)">
                  <i class="bi bi-trash-fill"></i>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Colonne 2 : Formulaire de création d'utilisateur -->
      <div class="user-form">
        <h3 class="text-center">Create a User</h3>
        <div class="mb-3">
          <label for="username" class="form-label">Username :</label>
          <input class="form-control" v-model="first" id="username" placeholder="Username" />
        </div>

        <div class="mb-3">
          <label for="email" class="form-label">Email :</label>
          <input class="form-control" v-model="last" id="email" placeholder="Email" />
        </div>

        <div class="mb-3">
          <label for="password" class="form-label">Password :</label>
          <input
            class="form-control"
            v-model="password"
            id="password"
            type="password"
            placeholder="Password"
          />
        </div>

        <div class="form-check mb-3">
          <input v-model="isManager" id="isManager" type="checkbox" class="form-check-input" />
          <label for="isManager" class="form-check-label">Is Manager</label>
        </div>

        <div class="buttons text-center">
          <button class="btn custom-create-btn" @click="create">Create</button>
        </div>
      </div>
    </div>

    <!-- Edit Modal -->
    <b-modal v-model="showModal" title="Update User" @close="closeModal" centered hide-footer>
      <template #modal-header>
        <h3>Update User</h3>
        <b-button variant="close" @click="closeModal">x</b-button>
      </template>
      <div class="mb-3">
        <label for="username" class="form-label">Username :</label>
        <b-form-input
          v-model="first"
          id="username"
          placeholder="Username"
          class="mb-2"
        ></b-form-input>
      </div>
      <div class="mb-3">
        <label for="email" class="form-label">Email :</label>
        <b-form-input v-model="last" id="email" placeholder="Email" class="mb-2"></b-form-input>
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password :</label>
        <b-form-input
          v-model="password"
          id="password"
          type="password"
          placeholder="Password"
          class="mb-2"
        ></b-form-input>
      </div>
      <div class="form-check mb-3">
        <input v-model="isManager" id="isManager" type="checkbox" class="form-check-input" />
        <label for="isManager" class="form-check-label">Is Manager</label>
      </div>
      <div class="d-flex justify-content-end mt-2 w-100">
        <b-button class="custom-create-btn" @click="update">Confirm</b-button>
        <b-button class="custom-delete-btn" @click="closeModal">Cancel</b-button>
      </div>
    </b-modal>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import {
  fetchUserById,
  fetchUsers,
  createUser,
  deleteUser,
  updateUser
} from '../repository/UserRepository'

const users = reactive([])
const selectedUserId = ref(null)
const prefix = ref('')
const first = ref('')
const last = ref('')
const password = ref('')
const isManager = ref(false)
const connectedUser = ref({})
const showModal = ref(false) // État pour afficher/masquer la modale

// Filtrage des utilisateurs
const filteredUsers = computed(() =>
  users.filter((user) => user.username.toLowerCase().startsWith(prefix.value.toLowerCase()))
)

// Chargement des utilisateurs
async function loadUsers() {
  const userData = await fetchUsers()
  if (userData && Array.isArray(userData)) {
    users.splice(
      0,
      users.length,
      ...userData.map((user) => ({
        id: user.id,
        username: user.username,
        email: user.email,
        password: user.password,
        is_admin: user.is_admin,
        is_manager: user.is_manager
      }))
    )
  }
}

// Création d'un nouvel utilisateur
async function create() {
  if (first.value && last.value && password.value) {
    await createUser({
      username: first.value,
      email: last.value,
      password: password.value,
      is_manager: isManager.value
    })
    first.value = last.value = password.value = ''
    isManager.value = false
    await loadUsers()
  }
}

// Suppression d'un utilisateur
async function del(userId) {
  if (userId) {
    await deleteUser(userId)
    await loadUsers()
  }
}

// Ouvrir la modale pour modifier l'utilisateur
function openModal(user) {
  selectedUserId.value = user.id
  first.value = user.username
  last.value = user.email
  password.value = user.password
  isManager.value = user.is_manager
  showModal.value = true
}

// Fermer la modale
function closeModal() {
  showModal.value = false
  selectedUserId.value = null
  first.value = last.value = password.value = ''
  isManager.value = false
}

// Mise à jour d'un utilisateur
async function update() {
  if (selectedUserId.value && first.value && last.value && password.value) {
    await updateUser(selectedUserId.value, {
      username: first.value,
      email: last.value,
      password: password.value,
      is_manager: isManager.value
    })
    closeModal()
    await loadUsers()
  }
}

// Déterminer le rôle de l'utilisateur
function getRole(user) {
  if (user.is_admin) {
    return 'Admin'
  } else if (user.is_manager) {
    return 'Manager'
  } else {
    return 'Salarié'
  }
}

// Chargement des utilisateurs au montage du composant
onMounted(async () => {
  await loadUsers()
  const loggedInUserId = '1'
  connectedUser.value = await fetchUserById(loggedInUserId)
})
</script>

<style scoped>
.user-management {
  display: flex;
  gap: 20px;
  justify-content: space-between;
}

.user-table {
  flex: 2;
}

.user-form {
  flex: 1;
  background-color: rgb(50, 48, 48);
  padding: 20px;
  border-radius: 10px;
  color: white;
}

/* Styles personnalisés pour les boutons */
.custom-edit-btn,
.custom-delete-btn,
.custom-create-btn {
  border-radius: 10px;
}

.custom-edit-btn {
  background-color: #2d5531;
  color: white;
}

.custom-edit-btn:hover {
  background-color: rgb(27, 100, 42);
}

.custom-delete-btn {
  background-color: #dc3545;
  color: white;
}

.custom-delete-btn:hover {
  background-color: #c82333;
}

.custom-edit-btn,
.custom-delete-btn {
  padding: 5px;
  border: none;
  background-color: transparent; /* Pour enlever le fond des boutons */
  cursor: pointer;
}

.custom-edit-btn i,
.custom-delete-btn i {
  font-size: 1.2rem; /* Ajustez la taille des icônes ici */
  color: #007bff; /* Couleur pour le crayon (modifier) */
}

.custom-delete-btn i {
  color: #dc3545; /* Couleur pour la poubelle (supprimer) */
}

.custom-create-btn {
  background-color: #007bff;
  color: white;
}

.custom-create-btn:hover {
  background-color: #0056b3;
}

/* Styles personnalisés pour la modale */
.custom-modal {
  background-color: rgb(50, 48, 48);
  color: white;
  border-radius: 15px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.modal-header,
.modal-footer {
  border-bottom: 1px solid #dee2e6;
}

/* Adjustments for input and tables */
input {
  display: block;
  margin-bottom: 10px;
}

label {
  margin-bottom: 5px;
  display: block;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

th,
td {
  text-align: center;
  border: 1px solid #3d3a3a;
  padding: 8px;
  color: white;
}

th {
  background-color: #2c2e2c;
}

/* Alternance de couleurs pour les lignes */
:deep(tbody tr:nth-child(even)) {
  background-color: #4f4e4e; /* Gris plus clair */
}

:deep(tbody tr:nth-child(odd)) {
  background-color: #212020; /* Gris foncé */
}

/* Hover effect for table rows */
:deep(tbody tr:hover) {
  background-color: #3a3a3a; /* Couleur de survol */
}

button {
  margin-right: 5px;
}

/* Mobile View */
@media (max-width: 768px) {
  .user-management {
    flex-direction: column;
  }

  .user-table,
  .user-form {
    width: 100%;
  }

  .user-table-wrapper {
    overflow-x: auto;
  }
}

/* Custom width for input */
.custom-width {
  width: 25%;
}

@media (max-width: 768px) {
  .custom-width {
    width: 100%;
  }
}
</style>
