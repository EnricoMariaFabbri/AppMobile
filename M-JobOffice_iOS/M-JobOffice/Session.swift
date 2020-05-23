

import UIKit
import Fabric
import Crashlytics

private let sharedSession = Session()

class Session: NSObject {
	
	class var sharedInstance: Session {
		return sharedSession
	}
	
	//var elencoRisultatiRicerca:Array<DocumentoBaseModel>?
	var parametriRicerca:Dictionary<String,Any>?
	var paginaRicerca: Int?
	var paginaTodoList: Int?
	var paginaListaFirme: Int?
	var elencoSelectionCheckCerca: Array<Bool>?
	
	
	var username: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_USERNAME) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_USERNAME)
		}
	}
	
	var password: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_PASSWORD) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_PASSWORD)
		}
	}
	
	var j2Username: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_J2PASSWORD) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_J2PASSWORD)
		}
	}
	
	var j2password: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_J2PASSWORD) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_J2PASSWORD)
		}
	}
	
	var isSMACEnabled: Bool? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_SMAC_ENABLED) as? Bool
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_SMAC_ENABLED)
		}
	}
	
	var SMACUrl: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_SMAC_URL) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_SMAC_URL)
		}
	}
	
	
	var servletUrl: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_SERVLET_URL) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_SERVLET_URL)
		}
	}

	var tokenGCM : String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_TOKENGCM) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_TOKENGCM)
		}
	}
	
	
	//var token : String? = "5gTQCVTRBJTMxM0NtUEOzIUL3MkNB1iQGZEOtIDRyQUMykzN"
	//var token = "5EzQEJkNzcTOxUkRtYjMyQTL2IkQ50CMGdTOtUEODRkNCJ0N"
	var token: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_TOKEN) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_TOKEN)
		}
	}
	
	
	//var deviceID = "123456"
	//var deviceID = "12345"
	var deviceID: String? {
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_DEVICE_ID) as? String
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_DEVICE_ID)
		}
	}
	
	var pinEnabled : Bool?{
		get {
			return UserDefaults.standard.value(forKey: USER_DEFAULT_PIN_ENABLED) as? Bool
		}
		set{
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_PIN_ENABLED)
		}
	}
	var pin : String?{
		get{
			return UserDefaults.standard.value(forKey: USER_DEFAULT_PIN_SEQUENCE) as? String
		}
		set{
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_PIN_SEQUENCE)
		}
	}
	var logoutTime : Int?{
		get{
			return UserDefaults.standard.value(forKey: USER_DEFAULT_LOGUT_TIME) as? Int
		}
		set{
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_LOGUT_TIME)
		}
	}
	var lastDate : Date?{
		get{
			return UserDefaults.standard.value(forKey: USER_DEFAULT_LAST_DATE) as? Date
		}
		set{
			UserDefaults.standard.setValue(newValue, forKey: USER_DEFAULT_LAST_DATE)
		}
	}

	

	
	func logUser() {
		Crashlytics.sharedInstance().setUserIdentifier(token!)
		Crashlytics.sharedInstance().setUserName(username)
		Crashlytics.sharedInstance().setValue(deviceID , forKey: "MobileId")
	}
	
	func logout(from viewController : UIViewController){
		
		deleteAll()
		let loginViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
		viewController.navigationController?.viewControllers = [loginViewController!]
	}
	
	func deleteAll(){
		
		//Delete record relativi agli utenti
		let repoUtenti = UtentiRepository()
		let repoListaAooUtenti = ListaAooUtenteRepository()
		repoUtenti.deleteAll()
		repoListaAooUtenti.deleteAll()
		let repoRelazioni = RelazioneRepository()
        let repoPeriodi = PeriodiRepository()
        let repoEnti = EntiRepository()
        let repoRichiesta = RichiestaRepository()

        repoEnti.deleteAll()
        repoPeriodi.deleteAll()
		repoRelazioni.deleteAll()
        //repoRichiesta.deleteAll()
		//Reset campi chiamate
		self.username = ""
		self.token = ""
		
	}
	
	
	
}
