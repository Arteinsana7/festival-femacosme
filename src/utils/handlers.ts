import { supabase } from './supabase'
import { toFestivalEvent } from '../data/FestivalEvents'
import type { ConcertTimetable, FestivalEvents } from '../data/FestivalEvents'

export async function fetchEvents(): Promise<FestivalEvents[]> {
  const { data, error } = await supabase
    .from('concert')
   .select(`
      id_concert, heure_debut, heure_fin, titre,
      scene ( id_scene, nom, lieu, categorie ( libelle ) ),
      jour ( id_jour, date_jour, libelle ),
      artiste ( id_artiste, nom, photo_url )
    `)
  if (error) throw error

  return (data as unknown as ConcertTimetable[])
    .sort((a, b) =>
      a.jour.date_jour.localeCompare(b.jour.date_jour) ||
      a.heure_debut.localeCompare(b.heure_debut)
    )
    .map(toFestivalEvent)
}

