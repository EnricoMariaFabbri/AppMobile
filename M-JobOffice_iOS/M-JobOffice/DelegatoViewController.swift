

import UIKit
import ActionSheetPicker_3_0

class DelegatoViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: Outlets
    @IBOutlet weak var textSurname: UITextField!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textBirthCity: UITextField!
    @IBOutlet weak var textBirthProvince: UITextField!
    @IBOutlet weak var textFiscalCode: UITextField!
    @IBOutlet weak var pickerBirthDate: UIButton!
    @IBOutlet weak var pickerGender: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonUndo: UIButton!
    
    // MARK: Vars
    var delegateIsNull: Bool?
    var variazione: Variazione?
    var delegate: DelegDelegate?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textSurname.delegate = self
        textName.delegate = self
        textBirthCity.delegate = self
        textBirthProvince.delegate = self
        textFiscalCode.delegate = self
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialize()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func initialize(){
        if variazione != nil{
            if delegateIsNull == false{
                textSurname.text = variazione!.cognomeDeleg ?? ""
                textName.text = variazione!.nomeDeleg ?? ""
                let gender = variazione!.sessoDeleg ?? -1
                if gender == 1 || gender == 2 {
                    if gender == 1{
                        pickerGender.setTitle("M",for: .normal)
                    }else{
                        pickerGender.setTitle("F",for: .normal)
                    }
                }else{
                    pickerGender.setTitle("Scegli sesso",for: .normal)
                }
                textBirthProvince.text = variazione!.provnascitaDeleg ?? ""
                textBirthCity.text = variazione!.luogonascitaDeleg ?? ""
                textFiscalCode.text = variazione!.cfsDeleg ?? ""
                pickerBirthDate.setTitle(variazione!.datanascitaDeleg ?? "Seleziona data di nascita", for: .normal)
            }else{
                textSurname.text = ""
                textName.text = ""
                pickerGender.setTitle("Scegli sesso",for: .normal)
                textBirthProvince.text = ""
                textBirthCity.text = ""
                textFiscalCode.text = ""
                pickerBirthDate.setTitle(variazione!.datanascitaDeleg ?? "Seleziona data di nascita", for: .normal)
                
            }
        }

        
    }
    
    func getDelegate() -> Variazione{
        variazione?.cognomeDeleg = textSurname.isEmpty() ? "" : textSurname.text
        variazione?.nomeDeleg = textName.isEmpty() ? "" : textName.text
        variazione?.luogonascitaDeleg = textBirthCity.isEmpty() ? "" : textBirthCity.text
        variazione?.provnascitaDeleg = textBirthProvince.isEmpty() ? "" : textBirthProvince.text
        variazione?.cfsDeleg = textFiscalCode.isEmpty() ? "" : textFiscalCode.text
        variazione?.datanascitaDeleg = pickerBirthDate.title(for: .normal)
        variazione?.sessoDeleg = pickerGender.title(for: .normal)?.uppercased() == "M" ? 1 : 2
        
        return variazione!
    }
    
    @IBAction func pickerGender(_ sender: UIButton) {
        let array = ["M", "F"]
        let initialSelection = 0
        let picker = ActionSheetStringPicker(title: "Scegli sesso",
                                             rows: array ,
                                             initialSelection: initialSelection,
                                             doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
                                                sender.setTitle("\(String(describing: selectedValue as? String != nil ? (selectedValue as! String) : ""))",for: .normal)
        }, cancel: nil ,
           origin: sender)
        picker?.show()
    }
    
    @IBAction func pickerBirthDate(_ sender: UIButton) {
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
    
    @IBAction func undo(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        delegate?.saveDelegate(variazione: getDelegate())
            if IS_IPHONE {
                dismiss(animated: true, completion: nil)
            }
    }
}
 

protocol DelegDelegate { 
    func saveDelegate(variazione: Variazione)
}

