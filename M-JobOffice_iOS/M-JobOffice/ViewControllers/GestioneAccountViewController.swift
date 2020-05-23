


import UIKit
import SwiftSpinner
import MMDrawerController


class GestioneAccountViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var btnDismissWidth: NSLayoutConstraint!
	@IBOutlet weak var btnDismiss: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var btnMenu: ButtonMenu!
	

	let repoUtenti = UtentiRepository()
	var elencoUtenti = Array<Utente>()
	var params = Dictionary<String,Any>()
	var utenteCorrente = Utente()
	var switchAccountDelegate : SwitchAccountDelegate?
	var selectedUtente = Utente()
	var modalCenter : CGPoint?
	var isDeleteAction = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		btnMenu.isHidden = IS_IPAD
		btnDismiss.isHidden = !IS_IPAD
		self.modalPinView.delegate = self
		
		if !IS_IPAD{
			btnDismissWidth.constant = 0
		}
		
		elencoUtenti = repoUtenti.getUtenti()
		utenteCorrente = elencoUtenti.filter({ (utente) -> Bool in
			utente.isSelezionato
		}).first!
		print(elencoUtenti)
		
	}
	
	@IBAction func dismiss(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		if elencoUtenti.count == 1 {
			UtilityHelper.presentAlertMessage("alert_attenzione".localized(), message: "Non è possibile deselezionare l'account perchè è l'unico presente.\nPer utilizzare l'app è necessario un accoun attivo", viewController: self)
			return
		}

		if elencoUtenti[indexPath.row].isSelezionato{
			UtilityHelper.presentAlertMessage("alert_attenzione".localized(), message: "alert_utente_gia_sel".localized(), viewController: self)
			return
		}
		
		let alertController = UIAlertController(title: "alert_attenzione".localized(), message: "sicuro di voler cambiare utente da \(utenteCorrente.sUsername) a \(Session.sharedInstance.username!)", preferredStyle: .actionSheet)
		let siAction = UIAlertAction(title: "alert_si".localized(), style: .default) { (action) in
			
			self.selectedUtente = self.elencoUtenti[indexPath.row]
			
			if self.selectedUtente.richiediPassword{
				self.showModalPin(isChangeUsersPassword: true)
			}else{
				self.changeUser(utente: self.selectedUtente)
			}
			
			
		}
		let noAction = UIAlertAction(title: "alert_annulla".localized(), style: .default) { (action) in
			return
		}
		alertController.addAction(siAction)
		alertController.addAction(noAction)
		self.present(alertController, animated: true, completion: nil)
		
	}
	
	func changeUser(utente : Utente){
		self.changeStatusUtente(utente: self.utenteCorrente, isOnline: false)
		self.utenteCorrente = utente
		self.changeStatusUtente(utente: self.utenteCorrente, isOnline: true)
		Session.sharedInstance.pinEnabled = utente.pinEnabled
		tableView.reloadData()
		
		//Ricarica le voci del menù
		if IS_IPAD{
			((((self.view.window?.rootViewController as! UINavigationController).viewControllers[0] as! ContainerViewController).drawer)?.leftDrawerViewController as! LeftDrawerTableViewController).reloadMenu()
			self.dismiss(animated: true, completion: {
					(UIApplication.shared.delegate as! AppDelegate).caricaAppunti()
			})
		}
		else{
			(self.mm_drawerController.leftDrawerViewController as! LeftDrawerTableViewController).reloadMenu()
			(UIApplication.shared.delegate as! AppDelegate).caricaAppunti()
		}
		//TODO : Mancheranno sicuro altri dati per customizzare l'interfaccia.
	}
	
	override func changeUserPasswordDoneCallBack() {
		if isDeleteAction {
			isDeleteAction = false
			deleteUtente(utente: self.utenteCorrente)
		}else{
			changeUser(utente: self.selectedUtente)
		}

	}
	
	func changeStatusUtente(utente : Utente, isOnline : Bool){
		
		if isOnline{
			utente.isSelezionato = true
			self.repoUtenti.selezionaUtente(byToken: utente.tokenUtente)
			self.sendStatus(status: SET_STATUS_ONLINE, token: utente.tokenUtente)
			Session.sharedInstance.username = utente.sUsername
			Session.sharedInstance.token = utente.tokenUtente
			Session.sharedInstance.pinEnabled = utente.pinEnabled
			Session.sharedInstance.logoutTime = utente.logoutTimer
			Session.sharedInstance.pin = utente.pinCode
		}
		else{
			utente.isSelezionato = false
			self.repoUtenti.deselezionaUtente(byToken: utente.tokenUtente)
			self.sendStatus(token: utente.tokenUtente)
		}
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return elencoUtenti.count
	}
	
	@IBAction func deleteAccount(_ sender: UIButton) {
		
		let contentView = sender.superview
		let cell = contentView?.superview as! AccountTableViewCell
		let indexPath = tableView.indexPath(for: cell)
		utenteCorrente = elencoUtenti[indexPath!.row]
		
		if utenteCorrente.isSelezionato{
			UtilityHelper.presentAlertMessage("alert_attenzione".localized(), message: "alert_del_account_attivo".localized(), viewController: self)
		}
		else{
			
			let alert = UIAlertController(title: "alert_attenzione".localized(), message: "alert_del_account".localized(), preferredStyle: .actionSheet)
			let ok = UIAlertAction(title: "alert_ok".localized(), style: .destructive, handler: { (action) in
				if self.utenteCorrente.richiediPassword{
					self.showModalPin(isChangeUsersPassword: true)
					self.isDeleteAction = true
				}else{
					self.deleteUtente(utente: self.utenteCorrente)
				}
			})
			let no = UIAlertAction(title: "alert_annulla".localized(), style: .default, handler: nil)
			alert.addAction(ok)
			alert.addAction(no)
			self.present(alert, animated: true, completion: nil)
			
		}
	}
	func deleteUtente(utente : Utente){
		self.repoUtenti.deleteUtente(byToken: utente.tokenUtente)
		var deleteIndex : Int?
		for i in 0...self.elencoUtenti.count-1{
			if self.elencoUtenti[i].tokenUtente == utente.tokenUtente{
				deleteIndex = i
			}
		}
		if deleteIndex != nil{
			self.elencoUtenti.remove(at: deleteIndex!)
		}
		self.tableView.reloadData()
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "gestioneAccountCell") as! AccountTableViewCell
		cell.initWithUtente(utente: elencoUtenti[indexPath.row])
		
		return cell
	}
	
	func sendStatus(status : String = "offline", token : String = Session.sharedInstance.token!){
		
		if Session.sharedInstance.tokenGCM != nil{
		
			params["token"] = token
			params["status"] = status
			params["arch"] = SET_STATUS_IOS_VALUE
			params["tokenGCM"] = Session.sharedInstance.tokenGCM!
			
			let wbs = WebService()
			let _ = wbs.setStatus(params).subscribe(onNext: { (data) in
				print(data ?? "nothing")
			}, onError: { (error) in
				print(error)
			}, onCompleted: {
				print("Completed")
			}, onDisposed: {
				print("Disposed")
			})
		}
		
	}
	
	@IBAction func addAccount(_ sender: UIButton) {
		let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
		loginViewController.fromGestioneAccount = true
		//let navigation = UINavigationController(rootViewController: loginViewController)
		self.navigationController?.pushViewController(loginViewController, animated: true)
	}
	
}
protocol SwitchAccountDelegate {
	func didFinishSwitchAccount() -> Void
}

extension UIView {
	func shake() {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.duration = 0.6
		animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
		layer.add(animation, forKey: "shake")
	}
	
	func redOnError(){
		
		UIView.animate(withDuration: 0.3, animations: {
			self.backgroundColor = UIColor.red
		}) { (finished) in
			UIView.animate(withDuration: 0.3, animations: {
				self.backgroundColor = UIColor(red:0.34, green:0.59, blue:0.71, alpha:1.00)
			})
		}
		
	}
}

extension UITextField{
	func isEmpty() -> Bool {
		return self.text == "" || self.text == nil
	}
	
	func highlightOnError(){
		UIView.animate(withDuration: 0.3, animations: {
			self.backgroundColor = UIColor.red.withAlphaComponent(0.2)
		}) { (_) in
			UIView.animate(withDuration: 0.3, animations: {
				self.backgroundColor = UIColor.clear
			})
		}
	}
}
