<script setup>
defineProps({
  msg: {
    type: String,
    required: true
  },
  username: {
    type: String,
  },
  email: {
    type: String,
  }
})
</script>

<template>
  <div class="greetings">
    <h1 class="green">{{ msg }}</h1>
    
    <h3>
      You’ve successfully created a project with
      <a href="https://vitejs.dev/" target="_blank" rel="noopener">Vite</a> +
      <a href="https://vuejs.org/" target="_blank" rel="noopener">Vue 3</a>.
      <p><strong>Username:</strong> {{ username }}</p>
      <p><strong>Email:</strong> {{ email }}</p>
    </h3>
  </div>
</template>

<style scoped>
h1 {
  font-weight: 500;
  font-size: 2.6rem;
  position: relative;
  top: -10px;
}

h3 {
  font-size: 1.2rem;
}

.greetings h1,
.greetings h3 {
  text-align: center;
}

.user-details {
  background-color: white;
  color: black;
  padding: 10px;
  margin-top: 20px;
  border-radius: 5px;
  display: inline-block;
  font-size: 1rem;
}

@media (min-width: 1024px) {
  .greetings h1,
  .greetings h3 {
    text-align: left;
  }
}
</style>
