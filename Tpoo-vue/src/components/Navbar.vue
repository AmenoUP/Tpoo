<template>
  <div class="w-100">
    <b-navbar toggleable="lg" class="custom-navbar">
      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="justify-content-center">
          <b-navbar-brand href="#">Welcome {{ username }}</b-navbar-brand>
          <b-nav-item :to="`/user`" class="mx-3">User</b-nav-item>
          <b-nav-item :to="`/chartManager/${userId}`" class="mx-3">Charts Manager</b-nav-item>
          <b-nav-item :to="`/workingTimes/${userId}`" class="mx-3">Working Times</b-nav-item>
          <b-nav-item :to="`/clock/${userId}`" class="mx-3">Clocks Manager</b-nav-item>
          <b-nav-item :to="`/LoginForm`" class="mx-3">Login</b-nav-item>
          <b-nav-item :to="`/Ticket`" class="mx-3">Ticket</b-nav-item>

          <!-- Affiche le bouton de signalement uniquement si l'utilisateur est authentifié -->
          <b-nav-item
            href="#"
            v-if="isAuthenticated"
            class="nav-link mx-3"
            @click="showReportModal = true"
          >
            <i class="bi bi-exclamation-octagon-fill"></i>
          </b-nav-item>

          <!-- Message pour les utilisateurs non authentifiés -->
          <b-nav-item v-else class="nav-link mx-3" disabled>
            <i class="bi bi-exclamation-octagon-fill"></i> Signaler un problème (Connectez-vous
            d'abord)
          </b-nav-item>

          <b-nav-item :to="`/LoginForm`" class="nav-link mx-3">
            <i class="bi bi-box-arrow-right"></i>
          </b-nav-item>
          <b-modal v-model="showReportModal" title="Signaler un problème" hide-footer>
            <div>
              <b-form-group label="Objet du problème">
                <b-form-input
                  v-model="problemSubject"
                  placeholder="Entrez l'objet du problème"
                ></b-form-input>
              </b-form-group>

              <b-form-group label="Détails du problème">
                <b-form-textarea
                  v-model="problemDetails"
                  placeholder="Décrivez le problème ici"
                  rows="3"
                ></b-form-textarea>
              </b-form-group>
            </div>

            <div class="d-flex justify-content-end mt-3">
              <b-button variant="secondary" @click="closeReportModal">Annuler</b-button>
              <b-button variant="primary" class="ml-2" @click="submitReport">Envoyer</b-button>
            </div>
          </b-modal>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
  </div>
</template>

<script>
import {
  BNavbar,
  BNavbarBrand,
  BNavbarToggle,
  BCollapse,
  BNavbarNav,
  BNavItem,
  BFormGroup,
  BFormInput,
  BFormTextarea,
  BButton,
  BModal
} from 'bootstrap-vue-next'
import 'bootstrap-icons/font/bootstrap-icons.css'
import { createTicket } from '../repository/TicketRepository'
import { mapState } from 'vuex' // Importer pour accéder aux états Vuex

export default {
  name: 'NavBar',
  components: {
    BNavbar,
    BNavbarBrand,
    BNavbarToggle,
    BCollapse,
    BNavbarNav,
    BNavItem,
    BFormGroup,
    BFormInput,
    BFormTextarea,
    BButton,
    BModal
  },
  data() {
    return {
      username: 'Username', // Remplacer par le user qui sera connecté
      userId: 1, // Remplacer par la méthode appropriée pour obtenir l'ID de l'utilisateur connecté
      showReportModal: false,
      problemSubject: '',
      problemDetails: ''
    }
  },
  computed: {
    ...mapState(['isAuthenticated']) // Accéder à l'état d'authentification du store
  },
  methods: {
    closeReportModal() {
      this.showReportModal = false
      this.problemSubject = ''
      this.problemDetails = ''
    },
    async submitReport() {
      const ticketData = {
        objet: this.problemSubject,
        issue: this.problemDetails
      }

      // Call createTicket with the userId
      await createTicket(ticketData, this.userId)

      // Reset form and close modal
      this.closeReportModal()
    }
  }
}
</script>

<style>
.custom-navbar {
  background-color: #484848; /* Couleur de fond de la barre de navigation */
}

.custom-navbar .nav-link {
  color: white !important; /* Couleur des liens de navigation */
}

.custom-navbar .navbar-brand,
.custom-navbar .bi-exclamation-octagon-fill,
.custom-navbar .bi-box-arrow-right {
  color: white !important; /* Couleur des icônes et du titre */
  font-size: 1.5rem; /* Ajuste la taille des icônes ici */
}

/* Couleur pour le lien actif */
.custom-navbar .router-link-active {
  color: #009951 !important; /* Couleur pour le lien actif */
}

/* Styles supplémentaires pour le bouton du menu burger */
.custom-navbar .navbar-toggler {
  border: none; /* Suppression de la bordure du bouton burger */
}

.modal-title {
  font-weight: bold;
  color: white;
}
</style>
