import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import ChartManager from '@/components/ChartManager.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/about',
      name: 'about',
      component: () => import('../views/AboutView.vue')
    },
    {
      path: '/user',
      name: 'user',
      component: () => import('../components/User.vue')
    },
    {
      path: '/chartManager/:userId',
      name: 'ChartManager',
      component: ChartManager
    },
    {
      path: '/workingTimes/',
      name: 'workingTimes',
      component: () => import('../components/WorkingTimes.vue')
    },
    {
      path: '/clock/:userId',
      name: 'ClockManager',
      component: () => import('../components/ClockManager.vue')
    }
  ]
})

export default router
