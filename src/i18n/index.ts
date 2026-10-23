import { createI18n } from 'vue-i18n'
import fr from './fr.json'
import en from './en.json'

const saved = localStorage.getItem('lang')
const browser = navigator.language.startsWith('fr') ? 'fr' : 'en'

export const i18n = createI18n({
    lagacy: false, 
    locale: saved ?? browser, 
    fallbackLocale: 'fr',
    messages: {
        fr,
        en
    }
})