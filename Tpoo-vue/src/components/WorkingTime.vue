<script setup>
fetch('http://localhost:4000/workingTimes/5')
  .then((response) => response.json())
  .then((data) => console.log(data))
</script>
<template>
  <h1>Working Times</h1>
</template>
