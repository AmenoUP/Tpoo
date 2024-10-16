<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { BButton, BModal, BTable, BFormInput } from 'bootstrap-vue-next'
import {
  getWorkingTimes,
  deleteWorkingTime,
  updateWorkingTime,
  addWorkingTime
} from '../repository/WorkingTimeRepository'

const userId = ref(3)
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

const fields = ['id', 'start', 'end', 'user_id', { key: 'actions', label: 'Actions' }]

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
  const route = useRoute()
  if (route.params.userID) {
    userId.value = route.params.userID
  }
  await fetchWorkingTimes()
})
</script>
<template>
  <div class="container">
    <h1>Working Times</h1>
    <b-button @click="showCreateModal">Create a WorkingTime</b-button>

    <!-- Create Modal -->
    <b-modal
      v-model="isCreateModalVisible"
      title="Create a New Working Time"
      @close="closeCreateModal"
      centered
      hide-footer
    >
      <template #modal-header>
        <h3>Create a New Working Time</h3>
        <b-button variant="close" @click="closeCreateModal">x</b-button>
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
        <b-button class="text-center" variant="primary" @click="saveWorkingTime">Save</b-button>
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
        <b-button variant="primary" @click="updateAWorkingTime">Save</b-button>
      </div>
    </b-modal>

    <b-table class="text-center mt-3" striped hover :items="workingTimes" :fields="fields">
      <template #cell(actions)="data">
        <div class="d-flex align-items-center justify-content-center">
          <b-button class="m-1" size="sm" @click="showEditModal(data.item)">Edit</b-button>
          <b-button class="m-1" size="sm" variant="danger" @click="handleDelete(data.item.id)"
            >Delete</b-button
          >
        </div>
      </template>
    </b-table>
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
</style>
