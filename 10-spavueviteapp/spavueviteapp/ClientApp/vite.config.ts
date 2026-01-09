import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

import appsettingsDev from '../appsettings.Development.json';

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    port: appsettingsDev.Vite.Server.Port,
    strictPort: true,
    hmr: {
      clientPort: appsettingsDev.Vite.Server.Port,
    },
  },
})
