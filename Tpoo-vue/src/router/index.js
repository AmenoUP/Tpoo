import { createRouter, createWebHashHistory } from 'vue-router';
import { useStore } from 'vuex';
import ChartManager from '@/components/ChartManager.vue';

const routes = [
  {
    path: '/user',
    name: 'user',
    component: () => import('../components/User.vue'),
    meta: { requiresAuth: true, requiredRole: 'admin' }, // Accessible uniquement pour admin
  },
  {
    path: '/chartManager/:userId',
    name: 'ChartManager',
    component: ChartManager,
    meta: { requiresAuth: true, requiredRole: 'manager' }, // Accessible uniquement pour manager
  },
  {
    path: '/workingTimes/:userId',
    name: 'workingTimes',
    component: () => import('../components/WorkingTimes.vue'),
    meta: { requiresAuth: true }, // Accessible pour tous les utilisateurs authentifiés
  },
  {
    path: '/clock/:userId',
    name: 'ClockManager',
    component: () => import('../components/ClockManager.vue'),
    meta: { requiresAuth: true }, // Accessible pour tous les utilisateurs authentifiés
  },
  {
    path: '/LoginForm',
    name: 'LoginForm',
    component: () => import('../components/LoginForm.vue'),
  },
  {
    path: '/ticket',
    name: 'ticket',
    component: () => import('../components/Ticket.vue'),
    meta: { requiresAuth: true, requiredRole: 'admin' }, // Accessible uniquement pour admin
  }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

// Ajouter une guard pour protéger les routes
router.beforeEach((to, from, next) => {
  const store = useStore(); // Accéder au store Vuex
  const isAuthenticated = store.state.isAuthenticated; // Vérifier l'état d'authentification
  const isAdmin = store.state.isAdmin; // Vérifier si l'utilisateur est admin
  const isManager = store.state.isManager; // Vérifier si l'utilisateur est manager

  // Vérifier si la route nécessite une authentification
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!isAuthenticated) {
      next({ name: 'LoginForm' }); // Rediriger vers la page de connexion si non authentifié
    } else {
      // Vérifier les rôles
      const requiredRole = to.meta.requiredRole;
      if (requiredRole === 'admin' && !isAdmin) {
        next({ name: 'LoginForm' }); // Rediriger si l'utilisateur n'est pas admin
      } else if (requiredRole === 'manager' && !isManager) {
        next({ name: 'LoginForm' }); // Rediriger si l'utilisateur n'est pas manager
      } else {
        next(); // Continuer vers la route
      }
    }
  } else {
    next(); // Continuer vers la route si pas de besoin d'authentification
  }
});

export default router;
