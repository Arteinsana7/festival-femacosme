<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { fetchEvents } from '../utils/handlers'
import type { FestivalEvents } from '../data/FestivalEvents'
import ConcertBlock from '../components/timetable/ConcertBlock.vue'

const events = ref<FestivalEvents[]>([])
const loading = ref(true)
const error = ref<string | null>(null)
const selectedDay = ref<string>('')

const days = computed(() => [...new Set(events.value.map((e) => e.day))])
const eventsOfDay = computed(() =>
  events.value.filter((e) => e.day === selectedDay.value),
)

onMounted(async () => {
  try {
    events.value = await fetchEvents()
    selectedDay.value = days.value[0] ?? ''
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Erreur de chargement'
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="timetable">
    <p v-if="loading">Chargement…</p>
    <p v-else-if="error">{{ error }}</p>

    <template v-else>
      <nav class="day-tabs" aria-label="Jours du festival">
        <button
          v-for="day in days"
          :key="day"
          :aria-pressed="day === selectedDay"
          :class="{ active: day === selectedDay }"
          @click="selectedDay = day"
        >
          {{ day }}
        </button>
      </nav>

      <div class="list">
        <ConcertBlock
          v-for="event in eventsOfDay"
          :key="event.id"
          :event="event"
        />
      </div>
    </template>
  </div>
</template>

<style scoped>
.timetable { padding: 0 var(--space-600) var(--space-1000); }
.day-tabs { display: flex; gap: var(--space-200); margin-bottom: var(--space-400); }
.day-tabs button {
  font-family: var(--font-main);
  font-size: 20px;
  padding: var(--space-200) var(--space-400);
  border: var(--border-width) solid var(--blue-500);
  background: var(--bg-primary);
  color: var(--blue-500);
  cursor: pointer;
}
.day-tabs button.active { background: var(--blue-500); color: var(--jaune-300); }
.list { display: flex; flex-direction: column; gap: var(--space-400); }
</style>