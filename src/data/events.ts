// definir le contrat interphare pour les elemnts 

export interface FestivalEvents {
    id: string;
    title: string;
    day: string;
    time: string;
    venue: string;
    category: string;
} 

export const events : FestivalEvents[] = [

    {
        id: 'concert-aurore',
        title : 'aurore^magnetique',
        day:'Vendredi' ,
        time :'20h30' ,
        venue:' Grand Scène',
        category :' concert',

    },
    {
        id: 'Atelier afficher',
        title : 'affiche en commun',
        day:'Samedi' ,
        time :'14h00' ,
        venue:' Ateliers',
        category :'Atelier Nord',

    },
    {
        id: 'Rencontre-ville',
        title : 'La ville comme scène',
        day:'Samedi' ,
        time :'17h30' ,
        venue:'Agora',
        category :'recontre',

    },
   
]

