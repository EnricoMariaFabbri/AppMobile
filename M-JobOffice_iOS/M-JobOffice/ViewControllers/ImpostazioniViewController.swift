

import UIKit
import Spring

class ImpostazioniViewController: BaseViewController, UITextFieldDelegate{
	

	
	@IBOutlet weak var pinEnableSwitch: UISwitch!
	@IBOutlet weak var lblTimeSection: UILabel!
	@IBOutlet weak var btnMenu: ButtonMenu!
	@IBOutlet weak var sliderController: UISlider!
	@IBOutlet weak var lblMinuti: UILabel!
	@IBOutlet weak var btnDismiss: UIButton!
	@IBOutlet weak var sliderContainer: SpringView!

	@IBOutlet weak var btnEditPin: UIButton!
	@IBOutlet weak var heightSliderCont: NSLayoutConstraint!
	@IBOutlet weak var changeUserPasswordSwitch: UISwitch!
	
	var pinEnabled : Bool?
	var lockTime : Int?
	var isConfermation = false
	var selectedPin : String?
	var isRemovingPin = false
	var isEditingPin = false
	var isChangeUsersPassword = false
	let userRepo = UtentiRepository()
	var utente : Utente?
	
	@IBAction func dismiss(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		btnDismiss.isHidden = !IS_IPAD
		
		utente = userRepo.getUtente(by: Session.sharedInstance.token!)
		modalPinView.delegate = self
		
		//Setting up switch pin
		pinEnabled = Session.sharedInstance.pinEnabled
		if(pinEnabled == nil){
			pinEnabled = false
			Session.sharedInstance.pinEnabled = pinEnabled
		}
		if (!pinEnabled!){
			sliderContainer.isHidden = true
			heightSliderCont.constant = 0
		}
		pinEnableSwitch.isOn = pinEnabled!
		
		//Setting up switch psw
		self.changeUserPasswordSwitch.isOn = utente!.richiediPassword
		
		lblTimeSection.text = "settings_time_lock_section".localized()
		
		//Setting up slide
		lockTime = Session.sharedInstance.logoutTime
		if(lockTime == nil){
			lockTime = 0
			Session.sharedInstance.logoutTime = lockTime
		}
		lblMinuti.text = "\(lockTime!) Minuti"
		sliderController.setValue(Float(exactly: lockTime!)!, animated: true)
		
	}
	
	

	
	@IBAction func valueChange(_ sender: UISlider) {
		lblMinuti.text = "\(Int(sender.value)) Minuti"
		Session.sharedInstance.logoutTime = Int(sender.value)
		userRepo.setLogoutTimer(byToken: Session.sharedInstance.token!, logoutTimer: Session.sharedInstance.logoutTime!)
		
	}
	@IBAction func switchOnChangeValue(_ sender: UISwitch) {
		if pinEnableSwitch.isOn{
			showSlider()
		}else{
			//isRemovingPin = true
			showModalPin(isRemovingPin: true)
		}
	}
	
	@IBAction func switchOnChangeValueUsersPassword(_ sender: UISwitch) {
		showModalPin(isChangeUsersPassword: true)
	}
	
	override func changeUserPasswordDoneCallBack() {
		userRepo.setRichiediPassword(byToken: Session.sharedInstance.token!, richiediPassword: changeUserPasswordSwitch.isOn)
	}
	
	override func resetCallback() -> Void {
		
		utente = userRepo.getUtente(by: Session.sharedInstance.token!)
		changeUserPasswordSwitch.isOn = utente!.richiediPassword
		pinEnableSwitch.isOn = utente?.pinEnabled != nil ? utente!.pinEnabled : false
		if !pinEnableSwitch.isOn {
			
			hideSlider()
		}
	}
	
	override func editingPinDoneCallback(newPin: String) {
		userRepo.setPinEnabled(byToken: Session.sharedInstance.token!, pinEnabled: pinEnableSwitch.isOn, pinCode: newPin)
	}
	
	override func removingPinDobeCallback() -> Void {
		userRepo.setPinEnabled(byToken: Session.sharedInstance.token!, pinEnabled: pinEnableSwitch.isOn, pinCode: "''")
		hideSlider()
	}
	override func EnableNewPinDoneCallBack(pin: String) {
		Session.sharedInstance.pinEnabled = pinEnableSwitch.isOn
		userRepo.setPinEnabled(byToken: Session.sharedInstance.token!, pinEnabled: pinEnableSwitch.isOn, pinCode: pin)
	}
	
	
	func showSlider(){
		sliderContainer.isHidden = false
		sliderContainer.animation = "fadeInRight"
		UIView.animate(withDuration: 0.7) {
			self.heightSliderCont.constant = 100
		}
		
		sliderContainer.animateNext {
			self.showModalPin()
		}
	}
	
	func hideSlider(){
		if self.heightSliderCont.constant != 0{
			sliderContainer.animation = "fadeOut"
			sliderContainer.animate()
			UIView.animate(withDuration: 0.7) {
				self.heightSliderCont.constant = 0
			}
		}
		
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let maxLength = 4
		guard let text = textField.text else { return true }
		let newLength = text.characters.count + string.characters.count - range.length
		return newLength <= maxLength
	}
	
	@IBAction func editPin(_ sender: UIButton) {
		showModalPin(isEditingPin: true)
	}
	
}
