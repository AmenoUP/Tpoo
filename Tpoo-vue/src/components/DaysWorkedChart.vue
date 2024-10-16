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

// Enregistrer les éléments nécessaires à Chart.js
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
  RadialLinearScale,
  Filler
)

// Props pour recevoir l'ID utilisateur
const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

// Les types de graphiques disponibles
const chartTypes = ['Bar', 'Line', 'Pie', 'Radar']
const selectedChartType = ref('Bar') // Type de graphique par défaut

// Composant dynamique selon le type de graphique sélectionné
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

// Données du graphique
const chartData = ref({
  labels: [],
  datasets: [
    {
      label: 'Days Worked',
      backgroundColor: '#007BFF',
      borderColor: '#01BD7E',
      data: []
    }
  ]
})

// Options du graphique
const chartOptions = {
  responsive: true,
  maintainAspectRatio: true
}

// Fonction exécutée lorsque le composant est monté
onMounted(async () => {
  const data = await getWorkingTimes(props.userId)
  updateChartData(data)
})

// Fonction pour mettre à jour les données du graphique
function updateChartData(data) {
  const daysWorkedPerMonth = {}

  data.forEach((item) => {
    const month = new Date(item.start).toLocaleString('default', { month: 'long' })

    if (daysWorkedPerMonth[month]) {
      daysWorkedPerMonth[month] += 1
    } else {
      daysWorkedPerMonth[month] = 1
    }
  })

  // Mise à jour réactive des labels et datasets
  chartData.value = {
    ...chartData.value,
    labels: Object.keys(daysWorkedPerMonth),
    datasets: [
      {
        ...chartData.value.datasets[0],
        data: Object.values(daysWorkedPerMonth)
      }
    ]
  }

  console.log('Données mises à jour:', chartData.value)
}
</script>

<template>
  <h3>Days Worked</h3>

  <!-- Sélecteur pour changer le type de graphique -->
  <label for="chartType">Choose Chart Type: </label>
  <select v-model="selectedChartType" id="chartType">
    <option v-for="type in chartTypes" :key="type" :value="type">{{ type }}</option>
  </select>

  <!-- Composant de graphique dynamique -->
  <component :is="chartComponent" :data="chartData" :options="chartOptions" />
</template>

<style scoped></style>
