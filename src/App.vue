<script setup lang="ts">
const festival = {
  name: "Festival",
  promise: "Best festival ever ",
};
import { ref } from "vue";

const isIntroductionVisible = ref(true);
</script>

<template>
  <header class="site header">
    <a class="brand" href="#">{{ festival.name }}</a>
    <nav aria-label="Navigation Principale">
      <a href="#highlights">Highlights</a>
    </nav>
  </header>
  <main>
    <section class="hero">
      <img src="./assets/logo.png" alt="Festival logo" />
      <p class="eyeborw">Festival associatif</p>
      <h1>{{ festival.promise }}</h1>
      <button @click="isIntroductionVisible = !isIntroductionVisible"></button>
    </section>
  </main>
</template>
