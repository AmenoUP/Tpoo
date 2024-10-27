<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { Bar, Line, Radar } from 'vue-chartjs'
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
const chartTypes = ['Bar', 'Line', 'Radar']
const selectedChartType = ref('Bar') // Type de graphique par défaut

// Composant dynamique selon le type de graphique sélectionné
const chartComponent = computed(() => {
  switch (selectedChartType.value) {
    case 'Line':
      return Line
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
      backgroundColor: '#FFC107', // Couleur de fond
      borderColor: '#FF8C00', // Couleur de bordure
      data: []
    }
  ]
})

// Options du graphique
const chartOptions = computed(() => ({
  responsive: true,
  maintainAspectRatio: true, // Pour maintenir le ratio lors du redimensionnement
  aspectRatio: window.innerWidth < 600 ? 1 : 2, // Ratio adapté aux petits écrans
  scales: {
    x: {
      beginAtZero: true
    },
    y: {
      beginAtZero: true
    }
  }
}))

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

// Fonction pour récupérer les données d'utilisateur
async function fetchUserData(userId) {
  const data = await getWorkingTimes(userId)
  updateChartData(data)
}

// Récupérer les données lors du montage initial
onMounted(async () => {
  if (props.userId) {
    await fetchUserData(props.userId)
  }
})

// Surveiller les changements d'ID utilisateur et mettre à jour les données en conséquence
watch(
  () => props.userId,
  async (newUserId) => {
    if (newUserId) {
      await fetchUserData(newUserId)
    }
  }
)
</script>

<template>
  <!-- Sélecteur pour changer le type de graphique -->
  <div class="chart-controls">
    <select v-model="selectedChartType" class="form-select chart-select" id="chartType">
      <option v-for="type in chartTypes" :key="type" :value="type">{{ type }}</option>
    </select>
  </div>

  <!-- Conteneur pour le graphique avec une classe CSS pour la taille -->
  <div class="chart-container">
    <!-- Composant de graphique dynamique -->
    <component :is="chartComponent" :data="chartData" :options="chartOptions" />
  </div>
</template>

<style scoped>
.chart-container {
  width: 100%;
  max-width: 70%;
  margin: 20px auto;
}

.chart-controls {
  display: flex;
  justify-content: flex-start;
  margin-bottom: 10px;
}

.chart-select {
  width: 150px;
  margin-right: 10px;
}

@media (max-width: 600px) {
  .chart-container {
    max-width: 90%;
  }

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
