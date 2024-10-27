<script setup>
import { ref, computed, onMounted } from 'vue'
import { fetchUsers } from '@/repository/UserRepository'
import HoursWorkedChart from '@/components/HoursWorkedChart.vue'
import DaysWorkedChart from '@/components/DaysWorkedChart.vue'
import AvgHoursWorkedChart from '@/components/AvgHoursWorkedChart.vue'

const selectedData = ref('hoursWorked')
const selectedUserId = ref(null) // Ajout pour sélectionner l'utilisateur

const users = ref([])

// Récupérer la liste des utilisateurs depuis l'API
onMounted(async () => {
  users.value = await fetchUsers()
  console.log(users.value) // Vérifiez que les utilisateurs sont bien récupérés
})

// Chart components disponibles
const chartComponents = {
  hoursWorked: HoursWorkedChart,
  daysWorked: DaysWorkedChart,
  avgHoursWorked: AvgHoursWorkedChart
}

// Calculer le composant de graphique en fonction de la sélection
const currentChartComponent = computed(() => {
  return chartComponents[selectedData.value]
})
</script>

<template>
  <div class="chart-manager">
    <h2>Charts Manager</h2>

    <!-- Conteneur pour les sélecteurs -->
    <div class="chart-controls">
      <!-- Select pour choisir l'utilisateur -->
      <select v-model="selectedUserId" class="form-select chart-select" id="user-select">
        <option value="Select a User" disabled>Select a User</option>
        <option v-for="user in users" :key="user.id" :value="user.id">
          {{ user.username }}
        </option>
      </select>

      <!-- Select pour choisir le type de graphique -->
      <select v-model="selectedData" class="form-select chart-select" id="data-type">
        <option value="hoursWorked">Hours Worked</option>
        <option value="daysWorked">Days Worked</option>
        <option value="avgHoursWorked">Average Hours Worked</option>
      </select>
    </div>

    <!-- Rendu du composant de graphique sélectionné, en passant l'userId -->
    <component :is="currentChartComponent" :userId="selectedUserId" />
  </div>
</template>

<style scoped>
.chart-manager {
  padding: 20px;
}

.chart-controls {
  display: flex;
  justify-content: flex-start;
  margin-bottom: 20px;
}

.chart-select {
  width: 400px;
  margin-right: 10px;
}

h2 {
  margin-bottom: 20px;
}

@media (max-width: 600px) {
  .chart-controls {
    flex-direction: column;
    align-items: flex-start;
  }

  .chart-select {
    width: 100%;
    margin-right: 0;
    margin-bottom: 10px;
  }
}
</style>
