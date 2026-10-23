<script setup lang="ts">
import TimetableView from './views/TimetableView.vue'

const festival = {
  name: 'Festival',
  promise: 'Best festival ever',
}
</script>

<template>
  <header class="site-header">
    <a class="brand" href="#">{{ festival.name }}</a>
    <nav aria-label="Navigation principale">
      <a href="#timetable">Programme</a>
    </nav>
  </header>

  <main>
    <section class="hero">
      <p class="eyebrow">Festival associatif</p>
      <h1>{{ festival.promise }}</h1>
    </section>

    <section id="timetable">
      <TimetableView />
    </section>
  </main>
</template>

<style scoped>
.site-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-400) var(--space-600);
}
.brand { font-weight: 700; font-size: var(--fs-body); color: var(--blue-500); text-decoration: none; }
.hero { padding: var(--space-1000) var(--space-600); }
.eyebrow { margin: 0; color: var(--blue-500); }
h1 { margin: var(--space-200) 0 0; }
</style>