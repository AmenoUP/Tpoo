<script setup>
import { ref, onMounted, computed } from 'vue'
import { Bar, Line, Pie, Radar } from 'vue-chartjs'
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  RadarController,
  CategoryScale,
  LinearScale,
  RadialLinearScale, // Enregistrement de l'échelle pour Radar et Pie
  Filler
} from 'chart.js'
import { getWorkingTimes } from '@/repository/WorkingTimeRepository'

// Enregistrer les différents éléments et échelles nécessaires à Chart.js
ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  RadarController,
  CategoryScale,
  LinearScale,
  RadialLinearScale, // Enregistrement de l'échelle RadialLinear
  Filler
)

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

// Les types de graphiques disponibles
const chartTypes = ['Bar', 'Line', 'Pie', 'Radar']
const selectedChartType = ref('Bar') // Type de graphique par défaut

const chartComponent = computed(() => {
  switch (selectedChartType.value) {
    case 'Line':
      return Line
    case 'Pie':
      return Pie
    case 'Radar':
      return Radar
    default:
      return Bar
  }
})

const chartData = ref({
  labels: [],
  datasets: [
    {
      label: 'Hours Worked',
      backgroundColor: '#01BD7E',
      borderColor: '#007BFF',
      data: []
    }
  ]
})

const chartOptions = {
  responsive: true,
  maintainAspectRatio: true
}

onMounted(async () => {
  try {
    const data = await getWorkingTimes(props.userId)
    updateChartData(data)
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error)
  }
})

function updateChartData(data) {
  const hoursByMonth = {}

  data.forEach((item) => {
    const start = new Date(item.start)
    const end = new Date(item.end)
    const hoursWorked = (end - start) / (1000 * 60 * 60)
    const month = start.toLocaleString('default', { month: 'long' })

    if (hoursByMonth[month]) {
      hoursByMonth[month] += hoursWorked
    } else {
      hoursByMonth[month] = hoursWorked
    }
  })

  // Mise à jour des labels et datasets de chartData
  chartData.value = {
    ...chartData.value,
    labels: Object.keys(hoursByMonth),
    datasets: [
      {
        ...chartData.value.datasets[0],
        data: Object.values(hoursByMonth)
      }
    ]
  }

  console.log('Mise à jour des données du graphique:', chartData.value)
}
</script>

<template>
  <h3>Hours Worked</h3>

  <!-- Sélecteur pour changer le type de graphique -->
  <label for="chartType">Choose Chart Type: </label>
  <select v-model="selectedChartType" id="chartType">
    <option v-for="type in chartTypes" :key="type" :value="type">{{ type }}</option>
  </select>

  <!-- Rendu dynamique du graphique selon le type sélectionné -->
  <component :is="chartComponent" :data="chartData" :options="chartOptions" />
</template>

<style scoped></style>
