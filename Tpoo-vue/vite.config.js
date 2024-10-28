import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  build: {
      outDir: './src-cordova/www/index.html', // Répertoire où Vite générera le build
      emptyOutDir: true // Nettoie le répertoire de destination avant le build
    },
    server: {
      host: '0.0.0.0',
      port: 5173, // assurez-vous que le port correspond à ce que Render attend
    }
})
