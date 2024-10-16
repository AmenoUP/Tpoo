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
  RadialLinearScale, // Pour Radar et Pie
  Filler
} from 'chart.js'
import { getWorkingTimes } from '@/repository/WorkingTimeRepository'

// Enregistrer les éléments nécessaires pour Chart.js
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
      label: 'Average Hours Worked',
      backgroundColor: '#FFC107',
      borderColor: '#FF8C00',
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
  const avgHoursByMonth = {}

  data.forEach((item) => {
    const start = new Date(item.start)
    const end = new Date(item.end)
    const month = start.toLocaleString('default', { month: 'long' })
    const hoursWorked = (end - start) / (1000 * 60 * 60) // Calcul des heures travaillées

    // Si le mois existe déjà, on ajoute les heures et les jours
    if (avgHoursByMonth[month]) {
      avgHoursByMonth[month].totalHours += hoursWorked
      avgHoursByMonth[month].days += 1
    } else {
      avgHoursByMonth[month] = { totalHours: hoursWorked, days: 1 }
    }
  })

  // Mise à jour réactive des labels et des datasets
  chartData.value = {
    ...chartData.value,
    labels: Object.keys(avgHoursByMonth),
    datasets: [
      {
        ...chartData.value.datasets[0],
        data: Object.values(avgHoursByMonth).map(
          (monthData) => monthData.totalHours / monthData.days // Moyenne des heures par jour
        )
      }
    ]
  }

  console.log('Données mises à jour:', chartData.value)
}
</script>

<template>
  <h3>Average Hours Worked per Day</h3>

  <!-- Sélecteur pour changer le type de graphique -->
  <label for="chartType">Choose Chart Type: </label>
  <select v-model="selectedChartType" id="chartType">
    <option v-for="type in chartTypes" :key="type" :value="type">{{ type }}</option>
  </select>

  <!-- Composant de graphique dynamique -->
  <component :is="chartComponent" :data="chartData" :options="chartOptions" />
</template>

<style scoped></style>
