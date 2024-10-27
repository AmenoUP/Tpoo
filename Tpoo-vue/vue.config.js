import { defineConfig } from '@vue/cli-service';

export default defineConfig({
  publicPath: '',
  pluginOptions: {
    cordovaPath: 'src-cordova'
  },
  devServer: {
    https: false,
    proxy: {
      '/api': {
        target: 'http://10.0.2.2:4000',
        changeOrigin: true,
      }
    }
  }
});