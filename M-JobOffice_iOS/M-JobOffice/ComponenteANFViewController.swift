
import UIKit
import ActionSheetPicker_3_0

class ComponenteANFViewController: BaseViewController {

	@IBOutlet var pickerParentela: UIButton!
	@IBOutlet var txtNome: UITextField!
	@IBOutlet var txtCognome: UITextField!
	@IBOutlet var pickerSesso: UIButton!
	@IBOutlet var txtLuogoNascita: UITextField!
	@IBOutlet var txtProvinciaNascita: UITextField!
	@IBOutlet var pickerData: UIButton!
	@IBOutlet var txtCF: UITextField!
	@IBOutlet var txtReddDipend: UITextField!
	@IBOutlet var txtReddAltro: UITextField!
	@IBOutlet var checkInabile: CheckBox!
	@IBOutlet var checkStudAppr: CheckBox!
	@IBOutlet var checkOrfano: CheckBox!
	@IBOutlet var checkFamiliare: CheckBox!
	@IBOutlet var componenteLbl: UILabel!
	
	let repo = RelazioneRepository()
	var arrayRel: [Relazione]?
	var familiare: FamiliareANF?
	var delegateFamiglia: FamiliareDelegate?
	var closer: EditingDelegate?
	var isKeyboardShowing = false
	var parentelaSelected: Int?
	var isSelectedSex = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
	
	func initialize() {
		if familiare != nil {
			componenteLbl.text = "Modifica componente"
            pickerParentela.setTitle(familiare!.relazione.desRel, for: .normal)
			pickerSesso.setTitle(familiare!.des_sesso!, for: .normal)
			pickerData.setTitle(familiare!.data_nascita!, for: .normal)
			txtNome.text = familiare!.nome!
			txtCognome.text = familiare!.cognome!
			txtCF.text = familiare!.cf!
			txtLuogoNascita.text = familiare!.luogo_nascita!
			txtProvinciaNascita.text = familiare!.prov_nascita!
			txtReddAltro.text = String(describing: familiare!.reddito_altro ?? 0)
			txtReddDipend.text = String(describing: familiare!.reddito_dipendente ?? 0)
			checkOrfano.checked = familiare!.flag_orfano ?? false
			checkOrfano.setImage(checkOrfano.checked ?  #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected") , for: .normal)
			checkInabile.checked = familiare!.flag_inabile ?? false
			checkInabile.setImage(checkInabile.checked ?  #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected") , for: .normal)
			checkFamiliare.checked = familiare!.flag_familiare ?? false
			checkFamiliare.setImage(checkFamiliare.checked ?  #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected") , for: .normal)
			checkStudAppr.checked = familiare!.flag_studappr ?? false
			checkStudAppr.setImage(checkStudAppr.checked ?  #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected") , for: .normal)
			if pickerSesso.title(for: .normal)! == "M" || pickerSesso.title(for: .normal)! == "F" {
				isSelectedSex = true
			}
		} else {
			componenteLbl.text = "Nuovo componente"
		}
        //print("GET ALL RESULT: ", repo.getAll())
		arrayRel = repo.getAll()
        //print("GET ALL RESULT: ", arrayRel?[2].codice)

	}
	
	func getFamiliare() -> FamiliareANF{
		let componenti = FamiliareANF()
        //componenti.codiceRelazione = self.parentelaSelected != nil ? self.parentelaSelected : 0
        componenti.relazione.desRel = pickerParentela.title(for: .normal);
        
        //componenti.relazione.codice = pickerParentela.index(ofAccessibilityElement: familiare!.relazione.codice);
        componenti.relazione.codice = arrayRel?[self.parentelaSelected ?? 0].codice
        componenti.desRelazione = pickerParentela.title(for: .normal);
        
		componenti.cognome = txtCognome.isEmpty() ? "" : txtCognome.text
		componenti.nome = txtNome.isEmpty() ? "" : txtNome.text
		componenti.cf = txtCF.isEmpty() ? "" : txtCF.text
		componenti.data_nascita = pickerData.title(for: .normal)
		componenti.des_sesso = pickerSesso.title(for: .normal)
		componenti.flag_orfano = checkOrfano.checked
		componenti.flag_inabile = checkInabile.checked
		componenti.flag_studappr = checkStudAppr.checked
		componenti.flag_familiare = checkFamiliare.checked
		componenti.reddito_dipendente = txtReddDipend.isEmpty() ? 0 : Double(txtReddDipend!.text!)
		componenti.reddito_altro = txtReddAltro.isEmpty() ? 0 : Double(txtReddAltro!.text!)
		componenti.prov_nascita = txtProvinciaNascita.text
		componenti.luogo_nascita = txtLuogoNascita.text
		componenti.sesso = pickerSesso.title(for: .normal)?.uppercased() == "M" ? 1 : 2
        componenti.id_anagrafe = familiare?.id_anagrafe
        componenti.idCompNucleo = familiare?.idCompNucleo
        
		return componenti
	}
	
	@IBAction func showPickerDate(_ sender: UIButton) {
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
		let array = arrayRel!
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli parentela",
											 rows: array.map({ (relazione) -> String in
												return "\(String(describing: relazione.desRelM!))/\(String(describing: relazione.desRelF!))"
											}),
											 initialSelection: initialSelection,
											 doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
												sender.setTitle("\(String(describing: selectedValue as? String != nil ? (selectedValue as! String) : ""))",for: .normal)
												self.parentelaSelected = selectedIndex
                                                print("PARENTELA SELEZIONATA: ", self.parentelaSelected)
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
		picker?.hideCancel = false
		picker?.show()
	}
    
    @IBAction func annulla(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        //print("IL FAMILIARE CHE DOVREBBE ESSERE SALVATO E' QUESTO:", getFamiliare().desRelazione)
        delegateFamiglia?.saveFamiliare(ComponentiNucleoANF: getFamiliare())
		if IS_IPHONE {
			dismiss(animated: true, completion: nil)
		}
	}
	
	override func keyboardWillShow(notifica:Notification) {
		if IS_IPHONE {
			self.view.addGestureRecognizer(tap)
		}
        if let keyboardSize = (notifica.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, !isKeyboardShowing{
			self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y - keyboardSize.height / 3)
			isKeyboardShowing = true
		}
	}
	override func keyboardWillHide(notifica:Notification) {
		if IS_IPHONE {
			self.view.removeGestureRecognizer(tap)
		}
        if let keyboardSize = (notifica.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y + keyboardSize.height / 3)
			isKeyboardShowing = false
		}
	}
	
	override func dismissKeyboard() {
		self.view.endEditing(true)
	}
}
