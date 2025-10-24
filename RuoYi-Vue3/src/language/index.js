import  {createI18n} from 'vue-i18n'
import ch from './ch.js'
import en from './en.js'


export const i18n = createI18n({
    legacy: false,
    globalInjection: true,
    locale: localStorage.getItem('lang') || 'cn',
    messages: {
        ch,
        en
    }
})
