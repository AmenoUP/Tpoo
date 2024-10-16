<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import HoursWorkedChart from '@/components/HoursWorkedChart.vue'
import DaysWorkedChart from '@/components/DaysWorkedChart.vue'
import AvgHoursWorkedChart from '@/components/AvgHoursWorkedChart.vue'

const selectedData = ref('hoursWorked')
const route = useRoute()
const userId = Number(route.params.userId)

const chartComponents = {
  hoursWorked: HoursWorkedChart,
  daysWorked: DaysWorkedChart,
  avgHoursWorked: AvgHoursWorkedChart
}

const currentChartComponent = computed(() => {
  return chartComponents[selectedData.value]
})
</script>

<template>
  <div>
    <h2>My Chart Manager</h2>

    <!-- Select for choosing dataset -->
    <label for="data-type">Select Data Type:</label>
    <select v-model="selectedData" id="data-type">
      <option value="hoursWorked">Hours Worked</option>
      <option value="daysWorked">Days Worked</option>
      <option value="avgHoursWorked">Average Hours Worked</option>
    </select>

    <!-- Render the selected chart component -->
    <component :is="currentChartComponent" :userId="userId" />
  </div>
</template>
