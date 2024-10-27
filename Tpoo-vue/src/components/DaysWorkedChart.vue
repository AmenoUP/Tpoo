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
  RadialLinearScale,
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
      label: 'Days Worked',
      backgroundColor: '#007BFF', // Couleur de fond
      borderColor: '#01BD7E', // Couleur de bordure
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
  const daysWorkedPerMonth = {}

  data.forEach((item) => {
    const month = new Date(item.start).toLocaleString('default', { month: 'long' })

    // Compter les jours travaillés par mois
    if (daysWorkedPerMonth[month]) {
      daysWorkedPerMonth[month] += 1
    } else {
      daysWorkedPerMonth[month] = 1
    }
  })

  // Mise à jour réactive des labels et datasets
  chartData.value = {
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
