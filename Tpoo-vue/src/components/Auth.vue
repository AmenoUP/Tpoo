<script setup>
import axios from 'axios';
import {ref} from "vue";

const connexion = () => {
  this.$router.push("/clock/1");
}

const email = ref('')
const password = ref('')

const signIn = async () => {
  try {
    const response = await axios.post('/users/sign_in', { email: this.email, password: this.password });
    localStorage.setItem('xsrfToken', response.data.xsrfToken);
    localStorage.setItem('userId', response.data.user_id);
    //localStorage.setItem('role', response.data.role);
    this.$router.push('/');
  } catch (error) {
    console.error(error);
}
};
</script>
<template>
  <div class="auth-container">
    <main class="auth-main">
      <h1 class="auth-title">Time Manager</h1>
      <section class="auth-form-container">
        <form @submit.prevent="signIn" class="auth-form">
          <div class="form-field">
            <label for="username" class="form-label">Username</label>
            <input id="username" type="text" class="form-input" placeholder="Enter username" />
          </div>
          <div class="form-field">
            <label for="email" class="form-label">Email</label>
            <input id="email" type="email" class="form-input" placeholder="Enter email" />
          </div>
          <div class="form-field">
            <label for="pasword" class="form-label">Email</label>
            <input id="password" type="text" class="form-input" placeholder="Enter your password" />
          </div>
          <button type="submit" class="submit-button">Connexion</button>
        </form>
      </section>
    </main>
  </div>
</template>

<style scoped>
.auth-container {
  background-color: #181818;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  align-items: center;
  padding: 0 15px 38px;
}

.auth-main {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.auth-title {
  color: #fff;
  margin-top: 60px;
  font: 80px/1 Righteous, sans-serif;
}

.auth-form-container {
  border-radius: 16px;
  background-color: #343a40;
  margin-top: 79px;
  width: 470px;
  max-width: 100%;
  padding: 61px 80px;
}

.auth-form {
  display: flex;
  width: 298px;
  max-width: 100%;
  flex-direction: column;
}

.form-field {
  display: flex;
  min-height: 87px;
  width: 100%;
  flex-direction: column;
  justify-content: start;
  font: 400 16px Inter, sans-serif;
  margin-bottom: 23px;
}

.form-label {
  color: #fff;
  line-height: 1.4;
  margin-bottom: 8px;
}

.form-input {
  border-radius: 8px;
  background-color: #fff;
  min-width: 240px;
  width: 100%;
  color: #1e1e1e;
  line-height: 1;
  padding: 12px 16px;
  border: 1px solid #d9d9d9;
}

.submit-button {
  align-self: center;
  border-radius: 8px;
  background-color: #2c2c2c;
  margin-top: 43px;
  min-height: 50px;
  width: 174px;
  max-width: 100%;
  color: #fff;
  padding: 17px 12px;
  font: 400 16px Inter, sans-serif;
  border: 1px solid #2c2c2c;
  cursor: pointer;
}
</style>