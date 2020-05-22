//
//  ComponenteNucleoViewController.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 25/05/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class ComponenteNucleoViewController: BaseViewController, UITextFieldDelegate  {
	
	
	@IBOutlet var componenteLbl: UILabel!
	@IBOutlet var viewToHide: UIView!
	@IBOutlet var pickerParentela: UIButton!
	@IBOutlet var txtNome: UITextField!
	@IBOutlet var txtCognome: UITextField!
	@IBOutlet var pickerSesso: UIButton!
	@IBOutlet var txtProvincia: UITextField!
	@IBOutlet var txtCF: UITextField!
	@IBOutlet var checkCarico: CheckBox!
	@IBOutlet var txtCarico: UITextField!
	@IBOutlet var checkStudAppr: CheckBox!
	@IBOutlet var pickerData: UIButton!
	@IBOutlet var txtLuogoNascita: UITextField!
	@IBOutlet var checkInabile: CheckBox!
	
	var arrayRel: [Relazione]?
	var parentelaSelected: Int?
	let picker = UIDatePicker()
	var delegateFamiglia: FamiliareDelegate?
	var isSelectedSex = false
	var familiare: Familiare?
	var closer: EditingDelegate?
	var isKeyboardShowing = false
	let repo = RelazioneRepository()
	
	override func viewDidLoad() {
        super.viewDidLoad()
        txtNome.delegate = self
        txtCognome.delegate = self
        txtProvincia.delegate = self
        txtCF.delegate = self
        txtCarico.delegate = self
        txtLuogoNascita.delegate = self
    }
	
	func initialize() {
		if familiare != nil {
			componenteLbl.text = "Modifica componente"
			pickerParentela.setTitle(familiare!.relazione.desRel, for: .normal)
			txtNome.text = familiare!.nome
			txtCognome.text = familiare!.cognome
			pickerSesso.setTitle(familiare!.des_sesso, for: .normal)
			txtLuogoNascita.text = familiare!.luogo_nascita
			txtProvincia.text = familiare!.prov_nascita
			pickerData.setTitle(familiare!.data_nascita, for: .normal)
			txtCF.text = familiare!.cf
			checkInabile.checked = familiare!.flag_inabile ?? false
			checkInabile.setImage(checkInabile.checked ?  #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected") , for: .normal)
			checkCarico.checked = familiare!.flag_carico ?? false
			checkCarico.setImage(checkCarico.checked ?  #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected") , for: .normal)
			checkStudAppr.checked = familiare!.flag_studappr ?? false
			checkStudAppr.setImage(checkStudAppr.checked ?  #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected") , for: .normal)
			txtCarico.text = "\(String(describing: familiare!.prc_carico ?? 0))%"
			if pickerSesso.title(for: .normal)! == "M" || pickerSesso.title(for: .normal)! == "F" {
				isSelectedSex = true
			}
		} else {
			componenteLbl.text = "Nuovo componente"
		}
		
		arrayRel = repo.getAll()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		initialize()
	}
	
	@IBAction func dismiss(_ sender: UIButton) {
		if IS_IPAD {
			closer?.close()
		} else {
			dismiss(animated: true, completion: nil)
		}
		
		delegateFamiglia?.setEdit()
	}
	func getFamiliare() -> Familiare{
		let familiare = Familiare()
		familiare.cf = txtCF.isEmpty() ? "" : txtCF.text
		familiare.cognome = txtCognome.isEmpty() ? "" : txtCognome.text
		familiare.nome = txtNome.isEmpty() ? "" : txtNome.text
		familiare.data_nascita = pickerData.title(for: .normal)
		familiare.des_sesso = pickerSesso.title(for: .normal)
		familiare.flag_carico = checkCarico.checked
		familiare.flag_inabile = checkInabile.checked
		familiare.flag_studappr = checkStudAppr.checked
		familiare.prc_carico = checkCarico.checked ? Double(txtCarico!.text!) : 0
		familiare.prov_nascita = txtProvincia.text
		familiare.luogo_nascita = txtLuogoNascita.text
		familiare.sesso = pickerSesso.title(for: .normal)?.uppercased() == "M" ? 1 : 2
		if parentelaSelected != nil {
			familiare.relazione.codice = arrayRel![parentelaSelected!].codice
			familiare.relazione.desRel = familiare.sesso == 1 ? arrayRel![parentelaSelected!].desRelM : arrayRel![parentelaSelected!].desRelF
		} else {
			if self.familiare != nil {
				familiare.relazione.codice = self.familiare!.relazione.codice!
				familiare.relazione.desRel = self.repo.getRel(by: familiare.relazione.codice!, isMan: familiare.sesso == 1)
			}
		}
		familiare.id_anagrafe = 0
		familiare.idgpx_dacdet = 0
		return familiare
	}
	
	@IBAction func showPicker(_ sender: UIButton) {
		let picker = ActionSheetDatePicker(title: "Seleziona data di nascita",
										   datePickerMode: .date,
										   selectedDate: Date(),
										   doneBlock: { (picker, value, index) in
											sender.setTitle(DateHelper.getCurrentDateCustomed(data: value as? Date), for: .normal)
		}, cancel: { (picker) in
			print("")
		}, origin: sender)
		picker!.show()
	}
	
	@IBAction func pickParentela(_ sender: UIButton) {
		let array = arrayRel
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli parentela",
											 rows: array!.map({ (relazione) -> String in
												return "\(String(describing: relazione.desRelM!))/\(String(describing: relazione.desRelF!))"
											}),
											 initialSelection: initialSelection,
											 doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
												self.parentelaSelected = selectedIndex
												sender.setTitle("\(String(describing: selectedValue as? String != nil ? (selectedValue as! String) : ""))",for: .normal)
		}, cancel: nil ,
		   origin: sender)
		picker?.show()
	}
	
	@IBAction func pickSesso(_ sender: UIButton) {
		let array = ["M", "F"]
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli sesso",
											 rows: array ,
											 initialSelection: initialSelection,
											 doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
												sender.setTitle("\(String(describing: selectedValue as? String != nil ? (selectedValue as! String) : ""))",for: .normal)
												self.isSelectedSex = true
		}, cancel: nil ,
		   origin: sender)
		picker?.show()
	}
	
    @IBAction func annulla(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
		if isSelectedSex {
			delegateFamiglia?.saveFamiliare(familiare: getFamiliare())
			if IS_IPHONE {
				dismiss(animated: true, completion: nil)
			}
		} else {
			UtilityHelper.presentAlertMessage("Errore", message: "Seleziona il sesso", viewController: self)
		}
	}
	
	override func keyboardWillShow(notifica:Notification) {
		if IS_IPHONE {
			self.view.addGestureRecognizer(tap)
		}
        if let keyboardSize = (notifica.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, !isKeyboardShowing{
			isKeyboardShowing = true
		}
	}
	override func keyboardWillHide(notifica:Notification) {
		if IS_IPHONE {
			self.view.removeGestureRecognizer(tap)
		}
        if let keyboardSize = (notifica.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			isKeyboardShowing = false
		}
	}
	
	override func dismissKeyboard() {
		self.view.endEditing(true)
	}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return true
       }
}

protocol FamiliareDelegate {
	func saveFamiliare(familiare: Familiare)
	func saveFamiliare(ComponentiNucleoANF: FamiliareANF)
	func setEdit()
}

