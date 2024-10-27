<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getCurrentTime, getCurrentDateTime, save } from '../repository/ClockManagerRepository.js'

const route = useRoute()
const userId = ref(route.params.userId)
const clockData = ref([])

const currentTime = ref(getCurrentTime()) // Heure actuelle
const currentDate = ref(new Date().toLocaleDateString()) // Date actuelle

const startDateTime = ref(null) // Vérifie si on est dans une période de travail
const clockIn = ref(false) // Statut de pointage
const logs = ref([]) // Historique des pointages
const statut = ref([]) // Statut
const message = ref('') // Message d'information
const error = ref(null) // Message d'erreur

// Détecter si l'utilisateur est en ligne ou hors ligne
const isOnline = ref(navigator.onLine)
const isOfflineMessage = ref(false) // Affichage du message de hors ligne

// Fonction pour stocker un horodatage dans le localStorage en mode hors ligne
const storeOfflineClock = (data) => {
  const offlineClocks = JSON.parse(localStorage.getItem('offlineClocks') || '[]')
  offlineClocks.push(data)
  localStorage.setItem('offlineClocks', JSON.stringify(offlineClocks))
  message.value = 'Pointage sauvegardé en mode hors ligne.' // Message pour le mode hors ligne
}

// Fonction pour envoyer les horodatages stockés en mode hors ligne dès que l'utilisateur est en ligne
const syncOfflineData = async () => {
  const offlineClocks = JSON.parse(localStorage.getItem('offlineClocks') || '[]')
  for (const data of offlineClocks) {
    try {
      await save(data, userId.value)
      offlineClocks.shift() // Supprime les horodatages envoyés
      localStorage.setItem('offlineClocks', JSON.stringify(offlineClocks))
      console.log('Offline clock sent successfully')
    } catch (error) {
      console.error('Failed to sync offline clock:', error)
      break
    }
  }
}

// Fonction principale de pointage
const clock = async () => {
  const time = getCurrentTime()
  const datetime = getCurrentDateTime()
  const data = { time: datetime, status: true }

  // Vérifier l'état de connexion
  if (isOnline.value) {
    try {
      const response = await save(data, userId.value)
      console.log('Clock created successfully')
      clockData.value.push(response)
      message.value = 'Pointage enregistré avec succès en ligne.' // Message pour le mode en ligne
    } catch (error) {
      console.error('Failed to create clock for this user:', error)
      storeOfflineClock(data) // Stocker en local si l'envoi échoue
    }
  } else {
    storeOfflineClock(data) // Stocke directement en local en cas de hors ligne
  }

  if (!clockIn.value) {
    logs.value.push({ action: 'Entrée', time, timestamp: Date.now() })
    startDateTime.value = time
    clockIn.value = true
  } else {
    logs.value.push({ action: 'Sortie', time, timestamp: Date.now() })
    startDateTime.value = null
    clockIn.value = false
  }
}

// Fonction pour rafraîchir le statut de travail
const refresh = () => {
  if (!clockIn.value) {
    statut.value.push({ action: 'Aucune période de travail en cours' })
  } else {
    const workProgress = `${progress(startDateTime.value, getCurrentTime())} (début: ${startDateTime.value})`
    statut.value.push({ action: `Temps de travail écoulé, ${workProgress}` })
  }
}

// Calcul du temps écoulé entre deux heures
const progress = (start, end) => {
  const [startHours, startMinutes, startSeconds] = start.split(':').map(Number)
  const [endHours, endMinutes, endSeconds] = end.split(':').map(Number)
  const startInSeconds = startHours * 3600 + startMinutes * 60 + startSeconds
  const endInSeconds = endHours * 3600 + endMinutes * 60 + endSeconds
  let elapsed = endInSeconds - startInSeconds

  if (elapsed < 0) {
    elapsed += 24 * 3600
  }

  const hours = Math.floor(elapsed / 3600)
  elapsed %= 3600
  const minutes = Math.floor(elapsed / 60)
  const seconds = Math.floor(elapsed % 60)

  return [hours, minutes, seconds].map((unit) => String(unit).padStart(2, '0')).join(':')
}

// Mettre à jour l'heure actuelle toutes les secondes
onMounted(() => {
  setInterval(() => {
    currentTime.value = getCurrentTime()
  }, 1000)

  // Détecter les changements de connexion et synchroniser les données hors ligne
  window.addEventListener('online', async () => {
    isOnline.value = true
    isOfflineMessage.value = false // Cache le message de mode hors ligne
    await syncOfflineData() // Synchroniser les données hors ligne
  })
  window.addEventListener('offline', () => {
    isOnline.value = false
    isOfflineMessage.value = true // Affiche le message de mode hors ligne
  })
})
</script>

<template>
  <div class="time-tracker">
    <!-- Conteneur pour aligner le titre en haut à gauche -->
    <div class="header">
      <h2>Clock Manager</h2>
    </div>

    <!-- Message d'avertissement pour le mode hors ligne -->
    <div v-if="isOfflineMessage" class="offline-message">
      <p>
        Vous êtes en mode hors ligne. Les données seront synchronisées lorsque la connexion sera
        rétablie.
      </p>
    </div>

    <!-- Affichage de la date et de l'heure actuelle -->
    <div class="current-time">
      <p class="date">{{ currentDate }}</p>
      <!-- Affiche la date du jour -->
      <p class="time">{{ currentTime }}</p>
      <!-- Affiche l'heure actuelle -->
    </div>

    <!-- Boutons d'entrée et de sortie -->
    <div class="buttons">
      <!-- Bouton pour rafraîchir le statut -->
      <button @click="refresh" class="btn btn-secondary">Statut</button>
      <!-- Bouton pour pointer -->
      <button @click="clock" class="btn btn-success">Pointer</button>
    </div>

    <!-- Messages d'information ou d'erreur -->
    <div v-if="message" class="message">
      <p>{{ message }}</p>
    </div>
    <div v-if="error" class="error">
      <p>{{ error }}</p>
    </div>

    <!-- Affichage du statut -->
    <div class="log">
      <h3>Période en cours</h3>
      <ul>
        <li v-for="(s, index) in statut" :key="index">
          {{ s.action }}
        </li>
      </ul>
    </div>

    <!-- Historique des pointages -->
    <div class="log">
      <h3>Historique des pointages</h3>
      <ul>
        <li v-for="log in logs" :key="log.timestamp">{{ log.action }} à {{ log.time }}</li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
.time-tracker {
  text-align: center;
  padding: 20px;
}

.header {
  display: flex;
  justify-content: flex-start;
}

.header h2 {
  margin: 0;
}

/* Message d'avertissement en mode hors ligne */
.offline-message {
  background-color: #ffcc00;
  color: #333;
  padding: 10px;
  margin-bottom: 15px;
  border-radius: 5px;
  font-weight: bold;
  text-align: center;
}

.current-time {
  margin: 20px 0;
}

.date {
  font-size: 1.5em;
  margin-bottom: 10px;
}

.time {
  font-size: 3em;
  font-weight: bold;
}

.buttons {
  margin: 20px 0;
}

button {
  margin: 0 10px;
  padding: 10px 20px;
  font-size: 1em;
}

.message {
  color: green;
  margin: 10px 0;
}

.error {
  color: red;
  margin: 10px 0;
}

.log {
  margin-top: 20px;
}

.log ul {
  list-style-type: none;
  padding: 0;
}

.log li {
  margin: 5px 0;
}
</style>
