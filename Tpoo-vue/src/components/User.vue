<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import { fetchUserById, fetchUsers, createUser, deleteUser, updateUser } from '../repository/UserRepository';

const users = reactive([]);
const selectedUserId = ref(null);
const prefix = ref('');
const first = ref('');
const last = ref('');
const connectedUser = ref({});
const showModal = ref(false); // État pour afficher/masquer la modale

// Filtrage des utilisateurs
const filteredUsers = computed(() =>
  users.filter((user) =>
    user.username.toLowerCase().startsWith(prefix.value.toLowerCase())
  )
);

// Chargement des utilisateurs
// async function loadUsers() {
//   const userData = await fetchUsers();
//   if (userData && Array.isArray(userData)) {
//     users.splice(0, users.length, ...userData.map(user => ({
//       id: user.id,
//       username: user.username,
//       email: user.email,
//     })));
//   }
// }

// Chargement des utilisateurs avec des données fictives
async function loadUsers() {
  const userData = [
    { id: 1, username: 'JohnDoe', email: 'john@example.com' },
    { id: 2, username: 'JaneSmith', email: 'jane@example.com' },
    { id: 3, username: 'AlexBrown', email: 'alex@example.com' }
  ];
  
  users.splice(0, users.length, ...userData);
}


// Création d'un nouvel utilisateur
async function create() {
  if (first.value && last.value) {
    await createUser({ username: first.value, email: last.value });
    first.value = last.value = '';
    await loadUsers();
  }
}

// Suppression d'un utilisateur
async function del(userId) {
  if (userId) {
    await deleteUser(userId);
    await loadUsers();
  }
}

// Ouvrir la modale pour modifier l'utilisateur
function openModal(user) {
  selectedUserId.value = user.id;
  first.value = user.username;
  last.value = user.email;
  showModal.value = true;
}

// Fermer la modale
function closeModal() {
  showModal.value = false;
  selectedUserId.value = null;
  first.value = '';
  last.value = '';
}

// Mise à jour d'un utilisateur
async function update() {
  if (selectedUserId.value && first.value && last.value) {
    await updateUser(selectedUserId.value, { username: first.value, email: last.value });
    closeModal();
    await loadUsers();
  }
}

// Chargement des utilisateurs au montage du composant
onMounted(async () => {
  await loadUsers();
  const loggedInUserId = '3'; 
  connectedUser.value = await fetchUserById(loggedInUserId);
});
</script>

<template>
  <div class="User">
    <div class="user-management">
      <!-- Colonne 1 : Tableau des utilisateurs -->
      <div class="user-table">
        <input v-model="prefix" placeholder="Recherche" />

        <table class="table table-dark table-striped">
          <thead>
            <tr>
              <th>Nom d'utilisateur</th>
              <th>Email</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody class="tbody">
            <tr v-for="user in filteredUsers" :key="user.id">
              <td>{{ user.username }}</td>
              <td>{{ user.email }}</td>
              <td>
                <button class="btn custom-edit-btn" @click="openModal(user)">Modifier</button>
                <button class="btn custom-delete-btn" @click="() => { del(user.id); }">Supprimer</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Colonne 2 : Formulaire de création d'utilisateur -->
      <div class="user-form">
        <h3>Créer un utilisateur</h3>
        <label>Nom d'utilisateur :</label>
        <input v-model="first" placeholder="Nom d'utilisateur" />

        <label>Email :</label>
        <input v-model="last" placeholder="Email" />

        <div class="buttons">
          <button class="btn custom-create-btn" @click="create">Créer</button>
        </div>
      </div>
    </div>

    <!-- Modale Bootstrap -->
    <div class="modal fade show" tabindex="-1" style="display: block;" v-if="showModal">
      <div class="modal-dialog">
        <div class="modal-content custom-modal">
          <div class="modal-header">
            <h5 class="modal-title">Modifier l'utilisateur</h5>
            <button type="button" class="btn-close" aria-label="Close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <label>Nom d'utilisateur : <input v-model="first" placeholder="Nom d'utilisateur" class="form-control"></label>
            <label>Email : <input v-model="last" placeholder="Email" class="form-control"></label>
          </div>
          <div class="modal-footer">
            <button class="btn custom-edit-btn" @click="update">Confirmer</button>
            <button class="btn custom-delete-btn" @click="closeModal">Annuler</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Utilisation de Flexbox pour séparer la page en deux colonnes */
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

/* Ajustements globaux pour le style */
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
  border: 1px solid #3d3a3a;
  padding: 8px;
  text-align: left;
  color: white; /* Le texte dans les cellules sera en blanc */
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

button {
  margin-right: 5px;
}
</style>

