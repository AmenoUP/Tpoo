<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { BButton, BModal, BFormInput } from 'bootstrap-vue-next'
import {
  getWorkingTimes,
  deleteWorkingTime,
  updateWorkingTime,
  addWorkingTime
} from '../repository/WorkingTimeRepository'

const route = useRoute()
const userId = ref(route.params.userId) // Récupérer l'ID de l'utilisateur à partir des paramètres de la route
const workingTimes = ref([])
const isCreateModalVisible = ref(false)
const isEditModalVisible = ref(false)
const currentWorkingTime = ref({})
const newWorkingTime = ref({
  start: '',
  end: '',
  user_id: userId.value
})

const formatDateTime = (dateTime) => {
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}`
}

// const fields = ['id', 'start', 'end', 'user_id', { key: 'actions', label: 'Actions' }]

const fetchWorkingTimes = async () => {
  try {
    workingTimes.value = await getWorkingTimes(userId.value)
    console.log(workingTimes.value)
  } catch (error) {
    console.error('Failed to fetch working times:', error)
  }
}

const handleDelete = async (workingTimeId) => {
  try {
    await deleteWorkingTime(userId.value, workingTimeId)
    workingTimes.value = workingTimes.value.filter((wt) => wt.id !== workingTimeId)
    console.log('Working time deleted successfully')
  } catch (error) {
    console.error('Failed to delete working time:', error)
  }
}

const showCreateModal = () => {
  isCreateModalVisible.value = true
}

const closeCreateModal = () => {
  isCreateModalVisible.value = false
}

const showEditModal = (workingTime) => {
  currentWorkingTime.value = { ...workingTime }
  console.log('Editing working time:', currentWorkingTime.value)
  isEditModalVisible.value = true
}

const closeEditModal = () => {
  isEditModalVisible.value = false
}

const saveWorkingTime = async () => {
  try {
    const formattedWorkingTime = {
      start: formatDateTime(newWorkingTime.value.start),
      end: formatDateTime(newWorkingTime.value.end)
    }
    console.log('Creating new working time:', formattedWorkingTime.start, formattedWorkingTime.end)

    const createdWorkingTime = await addWorkingTime(
      { workingtime: formattedWorkingTime },
      userId.value
    )
    console.log('Working time created successfully')
    workingTimes.value.push(createdWorkingTime)
  } catch (error) {
    console.error('Failed to create working time:', error)
  } finally {
    closeCreateModal()
  }
}

const updateAWorkingTime = async () => {
  console.log('Updating working time:', currentWorkingTime.value)
  console.log('User ID:', userId.value)
  try {
    const updatedWorkingTime = await updateWorkingTime(
      userId.value,
      currentWorkingTime.value.id,
      currentWorkingTime.value
    )
    console.log('Working time updated successfully')
    const index = workingTimes.value.findIndex((wt) => wt.id === updatedWorkingTime.id)
    if (index !== -1) {
      workingTimes.value[index] = updatedWorkingTime
    }
  } catch (error) {
    console.error('Failed to update working time:', error)
  } finally {
    closeEditModal()
  }
}

onMounted(async () => {
  await fetchWorkingTimes()
})
</script>

<template>
  <div class="mt-2 text-center">
    <h1>Working Times</h1>
  </div>
  <div class="m-3">
    <b-button @click="showCreateModal">Create a WorkingTime</b-button>
  </div>
  <div class="container">
    <!-- Create Modal -->
    <b-modal
      class="black"
      v-model="isCreateModalVisible"
      title="Create a New Working Time"
      @close="closeCreateModal"
      centered
      hide-footer
    >
      <template #modal-header>
        <p>Create a New Working Time</p>
      </template>
      <b-form-input
        v-model="newWorkingTime.start"
        type="datetime-local"
        placeholder="Start Date"
        class="mb-2"
      ></b-form-input>
      <b-form-input
        v-model="newWorkingTime.end"
        type="datetime-local"
        placeholder="End Date"
      ></b-form-input>
      <div class="d-flex justify-content-end mt-2 w-100">
        <b-button class="text-center custom-create-btn" @click="saveWorkingTime">Save</b-button>
      </div>
    </b-modal>

    <!-- Edit Modal -->
    <b-modal
      v-model="isEditModalVisible"
      title="Edit Working Time"
      @close="closeEditModal"
      centered
      hide-footer
    >
      <template #modal-header>
        <h3>Edit Working Time</h3>
        <b-button variant="close" @click="closeEditModal">x</b-button>
      </template>
      <b-form-input
        v-model="currentWorkingTime.start"
        type="datetime-local"
        placeholder="Start Date"
      ></b-form-input>
      <b-form-input
        v-model="currentWorkingTime.end"
        type="datetime-local"
        placeholder="End Date"
      ></b-form-input>
      <div class="d-flex justify-content-end mt-2 w-100">
        <b-button class="custom-create-btn" @click="updateAWorkingTime">Save</b-button>
      </div>
    </b-modal>

    <table class="table table-dark table-striped table-hover m-0 mt-3">
      <thead>
        <tr class="text-center">
          <th>ID</th>
          <th>Start</th>
          <th>End</th>
          <th>User ID</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr class="text-center" v-for="workingTime in workingTimes" :key="workingTime.id">
          <td>{{ workingTime.id }}</td>
          <td>{{ workingTime.start }}</td>
          <td>{{ workingTime.end }}</td>
          <td>{{ workingTime.user_id }}</td>
          <td>
            <div class="d-flex align-items-center justify-content-center">
              <button class="custom-edit-btn" @click="showEditModal(workingTime)">
                <i class="bi bi-pencil-fill"></i>
              </button>
              <button class="btn custom-delete-btn m-1" @click="handleDelete(workingTime.id)">
                <i class="bi bi-trash-fill"></i>
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.container {
  width: 100%;
  box-sizing: border-box;
}
h1 {
  text-align: center;
}

.table-dark {
  background-color: #343a40; /* Dark background */
  color: #f8f9fa; /* Light text for contrast */
}

.table-dark tbody tr:nth-child(odd) {
  background-color: #495057; /* Darker gray for odd rows */
}

.table-dark tbody tr:nth-child(even) {
  background-color: #6c757d; /* Lighter gray for even rows */
}

.table-dark thead {
  background-color: #212529; /* Very dark gray for the header */
  color: #fff; /* White text for header */
}

.table-dark th,
.table-dark td {
  border-color: #6c757d; /* Gray borders to blend with the table */
}

/* Hover effect for table rows */
.table-dark tbody tr:hover {
  background-color: #3a3a3a; /* Couleur de survol */
}

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

td,
th {
  text-align: center;
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
</style>
