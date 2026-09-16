<script setup lang="ts">
import { events } from "../data/events.ts";

import EventCard from "./event-card.vue";
</script>

<template>
  <section class="event-list">
    <EventCard v-for="event in events" :key="event.id" :event="event" />
  </section>
</template>
