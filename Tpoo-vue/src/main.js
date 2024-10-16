import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { BButton, BModal, BFormInput } from 'bootstrap-vue-next'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-next/dist/bootstrap-vue-next.css'

import './assets/main.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.component('BButton', BButton)
app.component('BModal', BModal)
app.component('BFormInput', BFormInput)

app.mount('#app')
