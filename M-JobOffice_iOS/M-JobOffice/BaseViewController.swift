//
//  BaseViewController.swift
//  AppSegreteria
//
//  Created by Sama Alessandro on 13/09/16.
//  Copyright © 2016 Sama Alessandro. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, MaggioliSecurityModalDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	var tap = UITapGestureRecognizer()
	var modalPinView = UINib(nibName: "ModalPin", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ModalPinView
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(notifica:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(notifica:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
		
        NotificationCenter.default.addObserver(self, selector: #selector(checkTimer), name: UIApplication.didBecomeActiveNotification, object: nil)
		
		
	}
	
	func resetCallback() {
		print("reset called")
	}
	func changeUserPasswordDoneCallBack() {
		print("change user password called")
	}
	func removingPinDobeCallback() {
		print("removing pin called")
	}
	func EnableNewPinDoneCallBack(pin: String) {
		print("Enable pin called")
	}
	func editingPinDoneCallback(newPin: String) {
		print("Editing pin called")
	}
	
    @objc func checkTimer(){
		if((UIApplication.shared.delegate as! AppDelegate).timeExpired){
			showModalPin(isFromBackGround: true)
		}
	}
    @objc func keyboardWillShow(notifica:Notification) {
		if IS_IPHONE {
			view.addGestureRecognizer(tap)
		}
		if scrollView != nil {
            if let keyboardSize = (notifica.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
				let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
				self.scrollView.contentInset = contentInsets;
				self.scrollView.scrollIndicatorInsets = contentInsets;
			}
		}
	}
	
    @objc func keyboardWillHide(notifica:Notification) {
		if IS_IPHONE {
			view.removeGestureRecognizer(tap)
		}
		if scrollView != nil {
			self.scrollView.contentInset = UIEdgeInsets.zero
			self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
		}
	}
	
	public func showModalPin(isFromBackGround: Bool = false, isChangeUsersPassword: Bool = false, isEditingPin: Bool = false, isRemovingPin : Bool = false, isConfermation : Bool = false){
		modalPinView.initializeView(by: self, isFromBackGround: isFromBackGround, isChangeUsersPassword: isChangeUsersPassword, isEditingPin: isEditingPin, isRemovingPin: isRemovingPin, isConfermation: isConfermation)
		modalPinView.frame = self.view.frame
		modalPinView.alpha = 0
		self.view.addSubview(modalPinView);
		UIView.animate(withDuration: 0.5) {
			self.modalPinView.alpha = 1
		}
	}
	
    @objc func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
}
