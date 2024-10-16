<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getCurrentTime, getCurrentDateTime, save } from '../repository/ClockManagerRepository.js'

const userId = ref(3)
const clockData = ref([]);

const currentTime = ref(getCurrentTime()); // Heure actuelle
const startDateTime = ref(null); // Vérifie si on est dans une période de travail
const clockIn = ref(false); // Statut de pointage
const logs = ref([]); // Historique des pointages
const statut = ref([]); // Statut
const message = ref(''); // Message d'information
const error = ref(null); // Message d'erreur

const refresh = () => {
  if (!clockIn.value) {
    statut.value.push({ action: 'Aucune période de travail en cours' });
  } else {
    const workProgress = `${progress(startDateTime.value, getCurrentTime())} (début: ${startDateTime.value})`;
    statut.value.push({ action: `Temps de travail écoulé, ${workProgress}` });
  }
}

const clock = async () => {
  const time = getCurrentTime()
  const datetime = getCurrentDateTime()
  try {
    const data = await save(
        {time: datetime, status: true},
        userId.value
    )
    console.log('Clock created successfully')
    clockData.value.push(data)
  } catch (error) {
    console.error('Failed to create clock for this user:', error)
  }
  if (!clockIn.value) {
    logs.value.push({ action: 'Entrée', time, timestamp: Date.now() });
    startDateTime.value = time;
    clockIn.value = true;
  } else {
    logs.value.push({ action: 'Sortie', time, timestamp: Date.now() });
    startDateTime.value = null;
    clockIn.value = false;
  }
}

const progress = (start, end) => {
  const [startHours, startMinutes, startSeconds] = start.split(':').map(Number);
  const [endHours, endMinutes, endSeconds] = end.split(':').map(Number);
  const startInSeconds = startHours * 3600 + startMinutes * 60 + startSeconds;
  const endInSeconds = endHours * 3600 + endMinutes * 60 + endSeconds;
  let elapsed = endInSeconds - startInSeconds;

  if (elapsed < 0) {
    // Cas où l'heure de fin est après minuit le jour suivant
    elapsed += 24 * 3600;
  }

  const hours = Math.floor(elapsed / 3600);
  elapsed %= 3600;
  const minutes = Math.floor(elapsed / 60);
  const seconds = Math.floor(elapsed % 60);

  return [hours, minutes, seconds]
      .map(unit => String(unit).padStart(2, '0'))
      .join(':');
}

// Mettre à jour l'heure actuelle toutes les secondes
onMounted(async () => {
  const route = useRoute()
  if (route.params.userID) {
    userId.value = route.params.userID
  }

  setInterval(() => {
    currentTime.value = getCurrentTime();
  }, 1000);
});
</script>

<template>
  <div class="time-tracker">
    <h1 class="green">CLOCK MANAGER</h1>

    <!-- Affichage de l'heure actuelle -->
    <div class="current-time">
      <p>{{ currentTime }}</p>
    </div>

    <!-- Boutons d'entrée et de sortie -->
    <div class="buttons">
      <button @click="refresh">Statut</button>
      <button @click="clock">Pointer</button>
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
      <h2>Statut</h2>
      <ul>
        <li v-for="(s, index) in statut" :key="index">
          {{ s.action }}
        </li>
      </ul>
    </div>

    <!-- Historique des pointages -->
    <div class="log">
      <h2>Historique des pointages</h2>
      <ul>
        <li v-for="log in logs" :key="log.timestamp">
          {{ log.action }} à {{ log.time }}
        </li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
.time-tracker {
  text-align: center;
  font-family: Arial, sans-serif;
}

.current-time {
  font-size: 2em;
  margin: 20px 0;
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