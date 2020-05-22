//
//  ModalPinView.swift
//  AppSegreteria
//
//  Created by Leonardo Canali on 19/05/17.
//  Copyright © 2017 Sama Alessandro. All rights reserved.
//

import UIKit

class ModalPinView: UIView, UITextFieldDelegate {

	
	@IBOutlet weak var appLogo: UIImageView!
	@IBOutlet weak var txtInputPin: UITextField!
	@IBOutlet weak var lblPinErrato: UILabel!
	@IBOutlet weak var btnCnfirm: UIButton!
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var btnDismiss: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	var isFromBackGround = false, isChangeUsersPassword = false, isEditingPin = false, isRemovingPin = false, isConfermation = false
	let userRepo = UtentiRepository()
	var selectedPin : String?
	var delegate : MaggioliSecurityModalDelegate?
	var view : UIViewController?
	
	func initializeView(by view : UIViewController, isFromBackGround: Bool = false, isChangeUsersPassword: Bool = false, isEditingPin: Bool = false, isRemovingPin : Bool = false, isConfermation : Bool = false){
		
		self.isFromBackGround = isFromBackGround
		self.isChangeUsersPassword = isChangeUsersPassword
		self.isEditingPin = isEditingPin
		self.isRemovingPin = isRemovingPin
		self.isConfermation = isConfermation
		self.view = view
		
	
		txtInputPin.keyboardType = .numberPad
		txtInputPin.delegate = self
		self.lblTitle.text = setTitle()
		self.isHidden = false
		self.alpha = 1
		lblPinErrato.alpha = 0
		appLogo.layer.cornerRadius = appLogo.frame.size.width / 2
		appLogo.clipsToBounds = true
		btnDismiss.isHidden = false
		
		
		
	}
	
	override func willMove(toWindow newWindow: UIWindow?) {
		super.willMove(toWindow: newWindow)
		if newWindow == nil {
			// UIView disappear
		} else {
			//UiView appear
		}

	}
	
	
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let maxLength = 4
		guard let text = textField.text else { return true }
		let newLength = text.characters.count + string.characters.count - range.length
		return newLength <= maxLength
	}
	
	func hide(){
		UIView.animate(withDuration: 0.5, animations: { 
			self.alpha = 0
		}) { (ok) in
			self.reset()
			self.removeFromSuperview()
		}
	}
	
	func wrongPing(text : String = "Pin errato"){
		lblPinErrato.text = text
		txtInputPin.shake()
		lblPinErrato.alpha = 1
		UIView.animate(withDuration: 0.7, animations: {
			self.lblPinErrato.alpha = 0
		})
	}
	
	func reset(){
		self.isHidden = true
		self.txtInputPin.text = ""
		self.txtInputPin.resignFirstResponder()
		self.txtInputPin.delegate = self
		self.txtInputPin.keyboardType = .numberPad
		self.lblTitle.text = "Scegliere un pin composto da 4 numeri"
		self.isConfermation = false
		self.isRemovingPin = false
		self.isEditingPin = false
		if (self.delegate != nil){
			self.delegate?.resetCallback()
		}

	}
	
	func setTitle() -> String{
		switch true {
		case isEditingPin:
			return "Inserire il pin precedente"
		case isRemovingPin:
			return "Inserire il pin per completare l'operazione"
		case isChangeUsersPassword:
			txtInputPin.delegate = nil
			txtInputPin.keyboardType = .default
			return "Inserire la  password per completare l'operazione"
		case isFromBackGround:
			btnDismiss.isHidden = true
			return "Sessione scaduta, Inserire il pin per accedere"
		default:
			return "Scegliere un pin composto da 4 numeri"
		}
	}

	@IBAction func dismissPressed(_ sender: Any) {
		hide()
	}
	
	@IBAction func confirm(_ sender: UIButton) {
		
		if isFromBackGround{
			
			if Session.sharedInstance.pin! == txtInputPin.text{
				hide()
				(UIApplication.shared.delegate as! AppDelegate).timeExpired = false
			}
			else{
				txtInputPin.shake()
				lblPinErrato.alpha = 1
				UIView.animate(withDuration: 0.7, animations: {
					self.lblPinErrato.alpha = 0
				})
			}

		}else{
			
			if !isChangeUsersPassword{
				
				if txtInputPin.text?.characters.count != 4{
					UtilityHelper.presentAlertMessage("Errore", message: "Il pin inserito deve essere composto da 4 numeri", viewController: self.view!)
				}else{
					
					
					
					if !isEditingPin{
						
						if !isRemovingPin{
							
							if(!isConfermation){
								selectedPin = txtInputPin.text!
								isConfermation = true
								lblTitle.text = "Inserire nuovamente il pin"
								txtInputPin.text = ""
								
							}
							else{
								if selectedPin == txtInputPin.text!{
									Session.sharedInstance.pin = selectedPin!
									delegate?.EnableNewPinDoneCallBack(pin: txtInputPin.text!)
									hide()
									
								}else{
									wrongPing()
								}
							}
						}else{
							if txtInputPin.text != Session.sharedInstance.pin!{
								wrongPing()
							}else{
								Session.sharedInstance.pin = nil
								Session.sharedInstance.pinEnabled = false
								delegate?.removingPinDobeCallback()
								hide()
								self.isRemovingPin = false
							}
						}
					}else{
						
						if Session.sharedInstance.pin! != txtInputPin.text! {
							wrongPing()
						}else{
							delegate?.editingPinDoneCallback(newPin: txtInputPin.text!)
							isEditingPin = false
							lblTitle.text = "Inserire il nuovo pin"
							txtInputPin.text = ""
						}
					}
					
					
				}
			} else {
				if UtilityHelper.checkPassword(input: txtInputPin.text!){
					delegate?.changeUserPasswordDoneCallBack()//Callback
					isChangeUsersPassword = false
					reset()
					
				}
				else{
					wrongPing(text: "Password errata")
				}
			}
			
		}
	}
	
}

protocol MaggioliSecurityModalDelegate {
	func changeUserPasswordDoneCallBack() -> Void
	func resetCallback() -> Void
	func editingPinDoneCallback(newPin : String) -> Void
	func removingPinDobeCallback() -> Void
	func EnableNewPinDoneCallBack(pin : String) -> Void
}
