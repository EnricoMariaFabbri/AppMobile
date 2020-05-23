

import UIKit

let NOTIFICA_DETTAGLIO_DOCUMENTO = "NOTIFICA_DETTAGLIO_APPUNTI"
let NOTIFICA_DETTAGLIO_CHAT = "NOTIFICA_DETTAGLIO_CHAT"
let NOTIFICA_FILTRO_TODO_LIST = "NOTIFICA_FILTRO_TODO_LIST"

//let NOTIFICA_DETTAGLIO_FIRME = "NOTIFICA_DETTAGLIO_FIRME"
//let NOTIFICA_DETTAGLIO_TODO_LIST = "NOTIFICA_DETTAGLIO_TODO_LIST"
//let NOTIFICA_DETTAGLIO_RISULTATO_RICERCA = "NOTIFICA_DETTAGLIO_RISULTATO_RICERCA"


let PAGE_SIZE = 20

enum TipoCellaAppunti : Int {
    case documento
    case contratto
    case determina
    case protocollo
}

enum TipoDocumento : String {
    case protocollo = "Protocollo"
    case determina = "Determina"
    case contratto = "Contratto"
    case documento = "Documento"
    case delibera = "Delibera"
}

enum NotificationsTypeEnum : String {
	case MSGCHAT = "msg.chat"
	case OTHERS = ""
}


enum TipoMenu : Int {
    case appunti = 1
    case preferiti
    case todoList
    case ricercaRepository
    case ricercaDocumentale
    case account
    case impostazioni
    case informazioni
    case logout
}

enum TipoFiltro : Int {
    case testoLibero
    case spinner
    case spinnerData
    case checkOrigin
}

enum TipoRicercaParametro : Int {
    case idFascicolo
    case idTipoDocumento
    case idClassificazione
    case oggetto
    case nominativo
    case registro
    case statoAssegnazione
    case tipoAssegnazione
    case allegati
    case dataInizio
    case dataFine
    case numeroDocumento
    case checkOrigin
    case dataRegInizio
    case dataRegFine
    case numRegistroInizio
    case numRegistroFine
    case ruolo
    case applicazione
}

enum TipoDatiInController : Int {
    case appunti
    case risultatiRicerca
}

enum TipoDocumentiFirma : Int {
    case allegati
    case listaFirma
}

enum TipoTodoButton : Int {
    case azioni
    case risposte
    case proposte
}

enum TipoFiltroTodoList : Int {
    case stato
    case tipoAssegnazione
    case ruolo
    case applicazione
    case contesto
    case periodo
    case dataDal
    case dataAl
}

enum TipoButtonCheckCerca : Int {
    case oggetto
    case tipo
    case numero
    case attivita
    case nome
    case richiedente
}

enum TipoRisultatoTodoListAction: Int {
    case COMPLETED
    case SUSPENDED_USER
    case SUSPENDED_SYSTEM
    case COMPLETED_NEED_RESYNC
    case FAILED
}



enum TipoSceltaUfficioUtenteSmista: Int {
    case competenza
    case conoscenza
}

enum TipoSmistaItem: String {
    case ufficio = "Office"
    case utente = "User"
}

enum VociMenu : String {
	case CEDOLINI = "cedapp"
	case CERTIFICAZIONE_UNICA = "cuapp"
	case VARIAZIONE_ACCREDITO = "varapp"
	case ANF = "anfapp"
	case DATI_FISCALI = "vdfapp"
    case TIMBRATURA = "carapp"
//	  case CURRICULUM = "curapp"
//    case ELENCO_MISSIONI_TRASFERTE = "emtapp"
//    case GESTIONE_MISSIONI_TRASFERTE = "gmtapp"
//    case DOCUMENTI_PERSONALI = "docpapp"
//    case BACHECA = "bacapp"
	
	static func getDynamicVoices() -> [VociMenu]{
        return [VociMenu.CEDOLINI, VociMenu.CERTIFICAZIONE_UNICA, VociMenu.VARIAZIONE_ACCREDITO, VociMenu.ANF, VociMenu.DATI_FISCALI, VociMenu.TIMBRATURA]
	}
}

let TODO_CLASSE_ATTIVITA_COMPLESSA_MOBILE = "it.saga.pubblici.delibere.actions.DlbSMCAttivitaManualeComplessaClient"
let TODO_CLASSE_ATTIVITA_COMPLESSA_CLIENT = "it.saga.pubblici.delibere.actions.DlbACTAttivitaManualeComplessaClient"
let TODO_CLASSE_ATTIVITA_SCELTA_MULTIPLA_MOBILE = "it.saga.pubblici.delibere.actions.DlbSMCHumanMultipleChoiceClient"
let TODO_CLASSE_ATTIVITA_SCELTA_MULTIPLA_CLIENT = "it.saga.pubblici.delibere.actions.DlbACTHumanMultipleChoiceClient"
let TODO_CLASSE_ATTIVITA_SEMPLICE_MOBILE = "it.saga.library.gestioneDocumentale.actions.DocFlowsWorkflowSMCActivity"
let TODO_CLASSE_ATTIVITA_SEMPLICE_CLIENT = "it.saga.library.gestioneDocumentale.actions.DocFlowsWorkflowClientActivity"
let TODO_CLASSE_ATTIVITA_SEMPLICE = "it.saga.library.gestioneDocumentale.actions.DocACTAttivitaClient"
let TODO_CLASSE_ATTIVITA_FIRMA_SINGOLA_MOBILE = "it.saga.library.gestioneDocumentale.actions.DocACTFirma"
let TODO_CLASSE_ATTIVITA_FIRMA_SINGOLA_CLIENT = "it.saga.library.gestioneDocumentale.actions.DocACTFirmaClient"
let TODO_CLASSE_ATTIVITA_FIRMA_MULTIPLA_MOBILE = "it.saga.library.gestioneDocumentale.actions.DocACTFirmaMultipla"
let TODO_CLASSE_ATTIVITA_FIRMA_MULTIPLA_CLIENT = "it.saga.library.gestioneDocumentale.actions.DocACTFirmaMultiplaClient"
let TODO_CLASSE_ATTIVITA_VISTI_PARERI_CLIENT = "it.saga.pubblici.delibere.actions.DlbACTRichiestaParereClient"
let TODO_CLASSE_ATTIVITA_VISTI_PARERI_MOBILE = "it.saga.library.gestioneDocumentale.actions.DlbACTRichiestaParere"



let CLASSI_ATTIVITA_SUPPORTATE = [TODO_CLASSE_ATTIVITA_COMPLESSA_MOBILE,
                                  TODO_CLASSE_ATTIVITA_COMPLESSA_CLIENT,
                                  TODO_CLASSE_ATTIVITA_SCELTA_MULTIPLA_MOBILE,
                                  TODO_CLASSE_ATTIVITA_SCELTA_MULTIPLA_CLIENT,
                                  TODO_CLASSE_ATTIVITA_SEMPLICE_MOBILE,
                                  TODO_CLASSE_ATTIVITA_SEMPLICE_CLIENT,
                                  TODO_CLASSE_ATTIVITA_SEMPLICE,
                                  TODO_CLASSE_ATTIVITA_FIRMA_SINGOLA_MOBILE,
                                  TODO_CLASSE_ATTIVITA_FIRMA_SINGOLA_CLIENT,
                                  TODO_CLASSE_ATTIVITA_FIRMA_MULTIPLA_MOBILE,
                                  TODO_CLASSE_ATTIVITA_FIRMA_MULTIPLA_CLIENT,
                                  TODO_CLASSE_ATTIVITA_VISTI_PARERI_CLIENT,
                                  TODO_CLASSE_ATTIVITA_VISTI_PARERI_MOBILE]


let SMISTA_ACTION_NAME = "action_smista"
let APRI_DOCUMENTO_ACTION = "action_apri_documento"


let NUMERO_PARAMETRI = 19
let NUMERO_FILTRI_BASE = 2

//MENU
let MENU_APPUNTI = "APPUNTI"
let MENU_PREFERITI = "PREFERITI"
let MENU_TODO_LIST = "TODO_LIST"
let MENU_RICERCA_DOCUMENTALE = "RICERCA_DOCUMENTALE"
let MENU_GESTIONE_ACCOUNT = "GESTIONE_ACCOUNT"
let MENU_IMPOSTAZIONI = "IMPOSTAZIONI"
let MENU_INFORMAZIONI = "INFORMAZIONI"
let MENU_LOGOUT = "LOGOUT"
let MENU_LISTE_FIRMA = "LISTA_FIRME"
let MENU_ACCOUNT_FIRMA = "ACCOUNT_FIRMA"
let MENU_CHAT = "CHAT"
let MENU_INTESTAZIONE = "INTESTAZIONE"




let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)
let IS_RETINA = (UIScreen.main.scale >= 2.0)

let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



//USER DEFAULT
let USER_DEFAULT_QR_CODE_MODEL = "QR_CODE_MODEL"
let USER_DEFAULT_USERNAME = "USERNAME"
let USER_DEFAULT_PASSWORD = "PASSWORD"
let USER_DEFAULT_J2USERNAME = "J2USERNAME"
let USER_DEFAULT_J2PASSWORD = "J2PASSWORD"
let USER_DEFAULT_SMAC_ENABLED = "SMAC_ENABLED"
let USER_DEFAULT_SMAC_URL = "SMAC_URL"
let USER_DEFAULT_SERVLET_URL = "SERVLET_URL"
let USER_DEFAULT_TOKENGCM = "TOKENGCM"
let USER_DEFAULT_TOKEN = "TOKEN"
let USER_DEFAULT_DEVICE_ID = "DEVICE_ID"
let USER_DEFAULT_LISTA_FILTRI = "LISTA_FILTRI"
let USER_DEFAULT_J2EEUSERNAME = "J2EEUSERNAME"
let USER_DEFAULT_ISTITUTION_ID = "ISTITUTION_ID"
let USER_DEFAULT_PIN_ENABLED = "PIN_ENABLED"
let USER_DEFAULT_PIN_SEQUENCE = "PIN_SEQUENCE"
let USER_DEFAULT_LOGUT_TIME = "LOGOUT_TIME"
let USER_DEFAULT_LAST_DATE = "LAST_DATE"

//Entry Point Web Service
let ENTRY_POINT_ACTIVATE = "activate"
let ENTRY_POINT_SET_STATUS = "setStatus"
let ENTRY_POINT_DEFAULT = "askMessage"


//SetStatus params
let SET_STATUS_ONLINE = "online"
let SET_STATUS_OFFILE = "offline"
let SET_STATUS_IOS_VALUE = "ios"

//Notitications
let SHOW_PREVIEW_NOTIFICATION = "SHOW_PREVIEW_NOTIFICATION"

//ERROR
let ONE_MEMBER = "Unico componente"
let WARNING = "Attenzione"
let ACC_NOT_LOAD = "Hai degli accertamenti non caricati, procedendo verranno reinseriti tra quelli da effettuare. Continuare?"
let GENERIC_ERROR = "Errore"
let GENERIC_ERROR_MESSAGE = "errore nella ricerca"
let OFFLINE = "Offline"
let SERVER = "Errore nel server"
let RESULT_DOWN = "Niente da scaricare"
let RESULT_UP = "Niente da caricare"
let TEMPO_SCADUTO = "Tempo scaduto"
let OFFLINE_ERROR = "-1009"
let OFFLINE_ERROR_MESSAGE = "A quanto pare sei offline, connettiti a internet"
let SERVER_ERROR = "274"
let SERVER_ERROR_MESSAGE = "Impossibile collegarsi al server nel tempo consentito (il server potrebbe essere spento, irraggiungibile o in manutenzione) riprovare più tardi"
let NO_RESULT = "271"
let NO_RESULT_MESSAGE = "I filtri impostati non hanno prodotto alcun risultato utile"
let NO_ACCERT_MESSAGE = "Non sono stati trovati accertamenti"
let NOTHING_VISITA = "270"
let ELAB_ERROR = "267"
let ELAB_ERROR_MESSAGE = "Si è verificato un errore durante l'elaborazione della richiesta, riprova più tardi"
let TOKEN_EXPIRED = "266"
let TOKEN = "Token scaduto"
let TOKEN_EXPIRED_MESSAGE = "Il token è inesistente o è stato disabilitato per inattività"
let NOTHING_VISITA_MESSAGE = "Nessuna visita da caricare"
let NOTHING_ACCERT_MESSAGE = "Non ci sono accertamenti da caricare"
let EMPTY_FIELDS_MESSAGE = "Compilare tutti i campi manualmente o tramite QR code."
let QR_ADVICE_MESSAGE = "Prima di effettuare il login è necessario attivare il dispositivo tramite il QR Code."
let TIME_EXPIRED = "-1001"
let TIME_EXPIRED_MESSAGE = "Tempo di richiesta scaduto."
let NOTHING_TO_LOAD = "270"
let NOTHING_TO_LOAD_MESSAGE = "Nessun dato da caricare"


















