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
      label: 'Hours Worked',
      backgroundColor: '#01BD7E',
      borderColor: '#007BFF',
      data: []
    }
  ]
})

// Options du graphique avec gestion du ratio d'aspect
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
  const hoursByMonth = {}

  data.forEach((item) => {
    const start = new Date(item.start)
    const end = new Date(item.end)
    const hoursWorked = (end - start) / (1000 * 60 * 60) // Calcul des heures travaillées
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

// Fonction pour récupérer les données de travail de l'utilisateur
async function fetchUserData(userId) {
  try {
    const data = await getWorkingTimes(userId)
    updateChartData(data)
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error)
  }
}

// Récupération des données lors du montage initial
onMounted(async () => {
  if (props.userId) {
    await fetchUserData(props.userId)
  }
})

// Surveiller les changements de l'ID utilisateur
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
    <!-- Rendu dynamique du graphique selon le type sélectionné -->
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
