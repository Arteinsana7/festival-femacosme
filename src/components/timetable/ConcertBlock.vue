<script setup lang="ts">
import type { FestivalEvents } from '../../data/FestivalEvents'

defineProps<{ event: FestivalEvents }>()
</script>

<template>
  <article class="card" :class="`card--${event.theme}`">
    <div class="card__photo">
      <img v-if="event.photo" :src="event.photo" alt="" loading="lazy" />
    </div>
    <div class="card__body">
      <h3 class="card__title">{{ event.title }}</h3>
      <p class="card__meta">{{ event.day }} · {{ event.time }}</p>
      <p class="card__venue">{{ event.venue }}</p>
      <span class="card__tag">{{ event.category }}</span>
    </div>
  </article>
</template>

<style scoped>
.card {
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
.card__photo {
  aspect-ratio: 3 / 2;
  background: var(--violette-900);
  border-radius: 10px 10px 0 0;
  overflow: hidden;
}
.card__photo img { width: 100%; height: 100%; object-fit: cover; display: block; }

.card__body {
  display: flex;
  flex-direction: column;
  gap: var(--space-200);
  padding: var(--space-600);
  border: 1px solid var(--ink);
  border-top: none;
}
.card__title { margin: 0; font-size: 32px; line-height: 38px; font-weight: 700; }
.card__meta { margin: 0; font-size: var(--fs-body); }
.card__venue { margin: 0; font-size: 16px; }

.card--jaune .card__body { background: var(--jaune-300); color: var(--ink); }
.card--bleu  .card__body { background: var(--blue-600);  color: var(--blue-text); }

.card__tag {
  align-self: flex-start;
  display: inline-flex;
  align-items: center;
  padding: var(--space-100) var(--space-400);
  margin-top: var(--space-200);
  background: var(--violette-300);
  color: var(--violette-900);
  border-radius: var(--radius-600);
  font-weight: 700;
}
</style>