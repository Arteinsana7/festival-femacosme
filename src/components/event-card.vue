<script setup lang="ts">
import { FestivalEvents } from "../data/FestivalEvents.ts";

defineProps<{
  event: FestivalEvents;
}>();
</script>

<template>
  <article class="event-card">
    <p class="event-day">{{ event.day }} . {{ event.time }}</p>
    <h3 class="event-title">{{ event.title }}</h3>
    <p class="event-venue">{{ event.venue }}</p>
    <span class="event-category">{{ event.category }}</span>
  </article>
</template>
