export interface FestivalEvents {
    id: number;
    title: string;
    day: string;
    time: string;
    venue: string;
    category: string;
     photo: string | null;
     theme: 'jaune' | 'bleu';
}

export interface ConcertTimetable {
    id_concert: number;
    heure_debut: string;
    heure_fin: string;
    titre: string | null;
    scene: {
        id_scene: number;
        nom: string;
        lieu: string | null;
        categorie: { libelle: string } | null;
    };
    jour: { id_jour: number; date_jour: string; libelle: string };
    artiste: {
        id_artiste: number;
        nom: string;
        photo_url: string | null;
    }[];
}

const formatHeure = (h: string) => {
    const [hh, mm] = h.split(':');
    return `${hh}h${mm}`;
};

export const toFestivalEvent = (c: ConcertTimetable): FestivalEvents => ({
    id: c.id_concert,
    title: c.titre ?? c.artiste.map((a) => a.nom).join(', '),
    day: c.jour.libelle,
    time: `${formatHeure(c.heure_debut)} - ${formatHeure(c.heure_fin)}`,
    venue: c.scene.lieu ?? c.scene.nom,
    category: c.scene.categorie?.libelle ?? '',
    photo: c.artiste[0]?.photo_url ?? null,
    theme: c.scene.categorie?.libelle === 'Électro-acoustique' ? 'bleu' : 'jaune',
});