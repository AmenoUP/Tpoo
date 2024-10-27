import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { BButton, BModal, BFormInput } from 'bootstrap-vue-next'
import store from './stores/store' // Assure-toi que ce chemin est correct
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-next/dist/bootstrap-vue-next.css'

import './assets/main.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)

// Utilise Pinia pour la gestion de l'état
app.use(createPinia())

// Si tu utilises Vuex, utilise ceci à la place
app.use(store)

// Enregistre les composants BootstrapVue
app.component('BButton', BButton)
app.component('BModal', BModal)
app.component('BFormInput', BFormInput)

// Monte l'application
app.use(router)
app.mount('#app')
