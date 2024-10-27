<template>
  <div class="Ticket m-2">
    <input class="form-control custom-width" v-model="prefix" placeholder="Recherche" />
  </div>
  <div class="ticket-management">
    <!-- Colonne 1 : Tableau des tickets -->
    <div class="ticket-table">
      <table class="table table-dark table-striped m-0">
        <thead>
          <tr>
            <th>Ticket ID</th>
            <th>Objet</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody class="tbody">
          <tr v-for="ticket in filteredTickets" :key="ticket.id">
            <td>{{ ticket.id }}</td>
            <td>{{ ticket.objet }}</td>
            <td>
              <button class="btn custom-view-btn" @click="viewTicket(ticket.id)">
                <i class="bi bi-eye-fill"></i>
              </button>
              <button class="btn custom-delete-btn" @click="() => deleteTicket(ticket.id)">
                <i class="bi bi-trash-fill"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Colonne 2 : Détails du ticket -->
    <div class="ticket-details" v-if="selectedTicket">
      <h3 class="text-center">Ticket Details</h3>
      <p><strong>User ID:</strong> {{ selectedTicket.id_user }}</p>
      <p><strong>Objet:</strong> {{ selectedTicket.objet }}</p>
      <p><strong>Issue:</strong> {{ selectedTicket.issue }}</p>
      <div class="buttons text-center">
        <button class="btn custom-delete-btn" @click="deleteTicket(selectedTicket.id)">
          Delete
        </button>
        <button class="btn custom-cancel-btn" @click="cancel">Cancel</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { fetchTickets, deleteTicketById } from '../repository/TicketRepository'
// import {fetchUserById} from '../repository/UserRepository'

const tickets = reactive([])
const selectedTicket = ref(null)
const prefix = ref('')

const filteredTickets = computed(() =>
  tickets.filter((ticket) => {
    const searchTerm = prefix.value.toLowerCase()
    return ticket.objet && ticket.objet.toLowerCase().includes(searchTerm)
  })
)

// Chargement des tickets
async function loadTickets() {
  const ticketData = await fetchTickets()
  console.log(ticketData) // Add this line to check the response
  if (ticketData && Array.isArray(ticketData)) {
    tickets.splice(
      0,
      tickets.length,
      ...ticketData.map((ticket) => ({
        id: ticket.id,
        objet: ticket.objet,
        issue: ticket.issue,
        id_user: ticket.id_user
      }))
    )
  }
}

// Afficher les détails du ticket
async function viewTicket(ticketId) {
  const ticket = tickets.find((t) => t.id === ticketId)
  if (ticket) {
    selectedTicket.value = ticket
    // Fetch username based on id_user if needed, you can implement it here
    // const user = await fetchUserById(ticket.id_user)
    // selectedTicket.value.username = user.username
  }
}

// Supprimer un ticket
async function deleteTicket(ticketId) {
  if (ticketId) {
    await deleteTicketById(ticketId)
    await loadTickets()
    selectedTicket.value = null // Clear selected ticket after deletion
  }
}

// Annuler la sélection du ticket
function cancel() {
  selectedTicket.value = null
}

// Chargement des tickets au montage du composant
onMounted(async () => {
  await loadTickets()
})
</script>

<style scoped>
.ticket-management {
  display: flex;
  gap: 20px;
  justify-content: space-between;
}

.ticket-table {
  flex: 2;
}

.ticket-details {
  flex: 1;
  background-color: rgb(50, 48, 48);
  padding: 20px;
  border-radius: 10px;
  color: white;
}

/* Styles personnalisés pour les boutons */
.custom-view-btn,
.custom-delete-btn,
.custom-cancel-btn {
  border-radius: 10px;
}

.custom-view-btn {
  background-color: #007bff;
  color: white;
}

.custom-view-btn:hover {
  background-color: #0056b3;
}

.custom-delete-btn {
  background-color: #dc3545;
  color: white;
}

.custom-delete-btn:hover {
  background-color: #c82333;
}

.custom-cancel-btn {
  background-color: #6c757d;
  color: white;
}

.custom-cancel-btn:hover {
  background-color: #5a6268;
}

/* Styles personnalisés pour la modale */
.ticket-table-wrapper {
  overflow-x: auto;
}
.custom-width {
  width: 25%;
}

@media (max-width: 768px) {
  .custom-width {
    width: 100%;
  }
}
</style>
