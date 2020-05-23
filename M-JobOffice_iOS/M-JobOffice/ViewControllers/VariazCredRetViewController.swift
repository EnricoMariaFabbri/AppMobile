

import UIKit
import ActionSheetPicker_3_0
import SwiftSpinner
import RxSwift

class VariazCredRetViewController: UIViewController, UITextFieldDelegate, DelegDelegate {
	
	
    @IBOutlet weak var btnTipologiaPagamento: UIButton!
    @IBOutlet weak var bsdStackMenu: BSDStackMenu!
	@IBOutlet weak var btnCmbModalita: UIButton!
	@IBOutlet weak var txtPaese: UITextField!
	@IBOutlet weak var txtCinEu: UITextField!
	@IBOutlet weak var txtCinIT: UITextField!
	@IBOutlet weak var txtABI: UITextField!
	@IBOutlet weak var txtCAB: UITextField!
	@IBOutlet weak var txtContoCorrente: UITextField!
	@IBOutlet weak var txtIstituto: UITextField!
	@IBOutlet weak var delegatoContainer: UIView!
	@IBOutlet weak var txtNomeDelegato: UILabel!
	@IBOutlet weak var txtSesso: UILabel!
	@IBOutlet weak var txtDataECitta: UILabel!
	@IBOutlet weak var txtcsfDelegato: UILabel!
	
	var variazioni = [Variazione]()
	var statiVars = [StatoVarModel]()
	var stringStati = [String]()
	var selectedVariazione : Variazione?
	var delegatoInsert : DelegatoViewModel?
	let jsonDecoder = JSONDecoder()
	let repo = VariazioneRepository()
    let pagaRepo = TipologiaPagamentoRepository()
	var selectedIndex = 0
    var delegateIsNull = false
    var count = 0
    var tipoPagamentoArray = [TipoPagamento]()
	var tipologiePagamento = [String]()
    let isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPaese.delegate = self
        txtABI.delegate = self
        txtCAB.delegate = self
        txtCinEu.delegate = self
        txtCinIT.delegate = self
        txtContoCorrente.delegate = self
        txtIstituto.delegate = self
        
        delegatoContainer.isHidden = true
        fetchAndStoreVariazioni {
            self.reloadData()
        }
        disableCell(Disable: true)
		
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        
	}
    
    
    @IBAction func paeseHasChanged(_ sender: UITextField) {
        accountType(byState: sender.text!.uppercased())
    }
    
    // MARK: qua manca da implementare il nuovo iban estero
    func accountType(byState state:String){
        if state == "IT" || state == "SM"{
            disableCell(Disable: false)
        }else{
            disableCell(Disable: true)
        }
    }
    
	
	func fetchAndStoreVariazioni(onCompletition completition : @escaping () -> ()){
		_ = SwiftSpinner.show("Caricamento", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
        
		let variazioniServer = WebService.sharedInstance.getVariazioni()
        let tipologiePagamentoServer = WebService.sharedInstance.getTipiPagamento()
        
        let _ = Observable.combineLatest(variazioniServer, tipologiePagamentoServer).subscribe(onNext: {(WSvariazioni, WSpagamenti) in

			self.repo.deleteAll()
            self.pagaRepo.deleteAll()
            
            //UserDefaults.standard.set(true, forKey: "Key")
			
            if let dict = WSvariazioni as? Dictionary<String,Any>{
                let varr = dict["var"] as? [[String:Any]]
                let varwait = dict["varwait"] as? [[String:Any]]
                let varref = dict["varref"] as? [[String:Any]]
                self.variazioni = []
                
                self.parseVariazioni(fromJSONArray: varr!, stato: .avviata)
                self.parseVariazioni(fromJSONArray: varwait!, stato: .attesa)
                self.parseVariazioni(fromJSONArray: varref!, stato: .rifiutata)
            }
            
            // salvataggio su db
            let dictPaga = WSpagamenti?["tipipag"] as? [Dictionary<String,Any>]
            for json in dictPaga!{
                let singlePayment = TipoPagamento(fromJSON: json)
                self.tipoPagamentoArray.append(singlePayment)
            }
            for payment in self.tipoPagamentoArray{
                
                self.pagaRepo.insertTipoPagamento(byTipoPagamento: payment)
            }
			completition()
		}, onError: { (error) in  
			print(error)
		}, onCompleted: {
			SwiftSpinner.hide()
			print("")
		}, onDisposed: {
			print("")
		})
	}
	
	func statiToString(){
		for s in statiVars{
			self.stringStati.append(s.stato!.rawValue)
		}
		if stringStati.count > 0{
			btnCmbModalita.setTitle(stringStati[0], for: .normal)
		}
	}
	
	func getTipi() -> [StatoVarModel] {
		let repo = VariazioneRepository()
		return repo.getStatiVariazioni()
	}
	
	func parseVariazioni(fromJSONArray jsonArray : [[String : Any]], stato : StatoVariazione){
		for varObject in jsonArray{
			do{
                var formatteOBJ = varObject
                switchKey(&formatteOBJ, fromKey: "ciniban", toKey: "cinIBAN")
                switchKey(&formatteOBJ, fromKey: "cinbban", toKey: "cinBBAN")
				let variazione = try Variazione(fromJSON: formatteOBJ)
				variazione.stato = stato
				repo.insertVariazione(byVariazione: variazione)
			}catch{
				print("Variaizone not parsed")
			}
		}
	}
    
    func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry
        }
    }

	
	func getVariazione(byID id : Int){
        self.selectedVariazione = self.repo.getVariazione(byID: id)
	}
	
	func populateView(){
		if let v = selectedVariazione{
			txtPaese.text = v.paese ?? "Nessun Paese"
			txtCinEu.text = "\(v.cineu!)"
			txtCinIT.text = v.cinit!
			txtABI.text = "\(v.abi!)"
			txtCAB.text = "\(v.cab!)"
			txtContoCorrente.text = v.conto!
			txtIstituto.text = v.desistituto!
			if v.iddelegato != nil {
                // se qui dentro allora modifica delegato ed elimina delegato
                // senno aggiungi delegato
                if v.nomeDeleg != nil && v.nomeDeleg != "" && v.cognomeDeleg != nil && v.cognomeDeleg != "" && v.cfsDeleg != nil && v.cfsDeleg != ""{
				delegatoContainer.isHidden = false
				txtNomeDelegato.text = "\(v.nomeDeleg!) \(v.cognomeDeleg!)"
				txtSesso.text = v.sessoDeleg! == 1 ? "MASCHIO" : "FEMMINA"
				txtDataECitta.text = "\(v.datanascitaDeleg ?? "") \(v.luogonascitaDeleg ?? "") (\(v.provnascitaDeleg ?? ""))"
				txtcsfDelegato.text = v.cfsDeleg!
                }else{
                    txtNomeDelegato.text = ""
                    txtSesso.text = ""
                    txtDataECitta.text = ""
                    txtcsfDelegato.text = ""
                }
            }
		}
	}
	
    @IBAction func pickerTipologiaPagamenti(_ sender: UIButton) {
        let initialSelection = 0
        let picker = ActionSheetStringPicker(title: "Scegli pagamento",
                                             rows: tipologiePagamento ,
                                             initialSelection: initialSelection,
                                             doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
                                                sender.setTitle("\(String(describing: selectedValue as? String != nil ? (selectedValue as! String) : ""))",for: .normal)
                                                let tipoPagamentoSelected = self.pagaRepo.getCodiceTipoPagamento(byNome: selectedValue as! String)
                                                self.repo.updateTipoPagamento(Variazione: (self.selectedVariazione?.varId!)!, TipoPagamento: tipoPagamentoSelected!)
                                                if (selectedValue as! String) == "Contanti"{
                                                    self.setContantiView()
                                                }
        }, cancel: nil ,
           origin: sender)
        picker?.show()
    }
    
    func disableCell(Disable disable:Bool){
        if disable{
            self.txtCinEu.isUserInteractionEnabled = false
            self.txtCinIT.isUserInteractionEnabled = false
            self.txtABI.isUserInteractionEnabled = false
            self.txtCAB.isUserInteractionEnabled = false
            self.txtContoCorrente.isUserInteractionEnabled = false
            self.txtIstituto.isUserInteractionEnabled = false
        }else{
            self.txtCinEu.isUserInteractionEnabled = true
            self.txtCinIT.isUserInteractionEnabled = true
            self.txtABI.isUserInteractionEnabled = true
            self.txtCAB.isUserInteractionEnabled = true
            self.txtContoCorrente.isUserInteractionEnabled = true
            self.txtIstituto.isUserInteractionEnabled = true
        }
    }
    
    func setContantiView(){
        self.txtPaese.text = ""
        self.txtCinEu.text = ""
        self.txtCinIT.text = ""
        self.txtABI.text = ""
        self.txtCAB.text = ""
        self.txtContoCorrente.text = ""
        self.txtIstituto.text = ""
        disableCell(Disable: true)
    }
    
    func checkAbiCab(){
		var params = [String:Any]()
		if !txtABI.isEmpty() && !txtCAB.isEmpty(){
			params["abi"] = selectedVariazione!.abi!
			params["cab"] = selectedVariazione!.cab!
			
			_ = SwiftSpinner.show("Caricamento", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
			_ = WebService.sharedInstance.chackAbiCab(params).subscribe(onNext: { (data) in
				if let dict = data as? [String:Any]{
					if let dictArr = dict["istcred"] as? [[String:Any]]{
						if dictArr.count > 0{
							if let idistcred = dictArr[0]["idistcred"] as? Double{
								print(idistcred)
								SuccessView.show(onViewController: self, isSucces: true)
							}else{
								SuccessView.show(onViewController: self, isSucces: false)
							}
						}
					}
				}
			}, onError: { (error) in
				print("Errore durante la verifica di ABI e CAB: \(error)")
			}, onCompleted: {
				SwiftSpinner.hide()
				print("Completed")
			}, onDisposed: {
				print("Disposed")
			})
		}
		
	}
	
	func deleteVariazione(byID id : Int){
		var params = [String:Any]()
		params["varidwkf"] = id
		_ = WebService.sharedInstance.deleteVariazione(params).subscribe(onNext: { (data) in
			if let dict = data as? [String:Any]{
				if let dictArr = dict["delvar"] as? [[String:Any]]{
					if dictArr.count > 0{
						if let esito = dictArr[0]["esito"] as? Bool{
							if esito{
								UtilityHelper.presentAlertMessage("Completato", message: "La variazione è stata cancellata correttamente", viewController: self)
							}else{
								UtilityHelper.presentAlertMessage("Errore", message: "Errore durante la cancellazione della variazione", viewController: self)
							}
						}
					}
				}
			}
		}, onError: { (error) in
			print("Errore durante l'eliminazine di una variazione: \(error)")
		}, onCompleted: {
			print("Completed")
		}, onDisposed: {
			print("Disposed")
		})
	}
	
	
	@IBAction func showPicker(_ sender: UIButton) {
		if statiVars.count > 0 {
            let allVariazioni = self.repo.getVariazioni()
            stringStati = []
            for variazioni in allVariazioni{
                stringStati.append(variazioni.stato!.rawValue + "--" + String(variazioni.varId!))
            }

			let picker = ActionSheetStringPicker(title: "Scegli valore", rows: self.stringStati, initialSelection: 0, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
				
				sender.setTitle("\(selectedValue as? String != nil ? selectedValue as! String : "Nessuno stato" )",for: .normal)
                
                self.getVariazione(byID: self.getIdBySelectedValue(SelectedValue: (selectedValue as? String)!))
				self.populateView()
				self.setupStackButton()
				
				
			}, cancel: nil , origin: sender)
			picker?.hideCancel = true
			picker?.show()
		}
	}
	
    func getIdBySelectedValue (SelectedValue selectedValue:String) -> Int{
        let arrayId = selectedValue.components(separatedBy: "--")
        let id = Int(arrayId[1])
        return id!
    }
	
	func setupStackButton(){

		var buttons = [BSDStackMenuCell]()
		
		let btnDeleteDelegate = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_delete") , title: "Elimina delegato", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
            self.repo.deleteDelegate(Variazione: self.selectedVariazione!)
            self.bsdStackMenu.closeMenu()
            self.reloadData()
            UtilityHelper.presentAlertMessage("Attenzione", message: "Delegato Eliminato", viewController: self)
		}
		let btnAddRequest = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_add_stack"), title: "Aggiungi richiesta", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			self.loadRequest()
            self.bsdStackMenu.closeMenu()
		}
		let btnEditDelegate = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_add_delegate_stack"), title: "Modifica delegato", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
                self.performSegue(withIdentifier: "segueDelegatoViewController", sender: self)
            self.bsdStackMenu.closeMenu()
			
		}
        let btnAddDelegate = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_add_delegate_stack"), title: "Aggiungi delegato", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
                self.performSegue(withIdentifier: "segueDelegatoViewController", sender: self)
            self.bsdStackMenu.closeMenu()
            
        }
		let btncheckAbiCab = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_munic_stack"), title: "Verifica ABI e CAB", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			self.checkAbiCab()
            self.bsdStackMenu.closeMenu()
		}
		let btnDeleteRequest = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_delete"), title: "Elimina richiesta", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			if let variazione = self.selectedVariazione{
				self.deleteVariazione(byID:variazione.varId!)
                self.reloadData()
                self.bsdStackMenu.closeMenu()
               
			}
			
		}
		
		if selectedVariazione != nil{
			buttons = [btnDeleteRequest, btncheckAbiCab, btnAddRequest]
			
            if (selectedVariazione!.iddelegato != nil && selectedVariazione!.cfsDeleg != nil && selectedVariazione!.nomeDeleg != nil && selectedVariazione!.cognomeDeleg != nil) {
				buttons.append(btnDeleteDelegate)
				buttons.append(btnEditDelegate)
                delegateIsNull = false
			}else{
                delegateIsNull = true
				buttons.append(btnAddDelegate)
			}
		}else{
            delegateIsNull = true
			buttons = [btnAddRequest, btnAddDelegate, btncheckAbiCab]
		}
		
		bsdStackMenu!.initialize(by: buttons)
	}
	
	func actionClicked(cell: BSDStackMenuCell) {
		
	}
    
	
	func loadRequest(){
        getUpdatesPayment()
		if !emptyfieldExists() {
            
            let richiestaVariazione = self.repo.getVariazione(byID: selectedVariazione!.varId!)
			
			let params = richiestaVariazione!.toJSON()
            print("b-b-b-b-b-b-b-b-b-b-b-b-")
            print(params)
			_ = WebService.sharedInstance.addNewVariazione(params).subscribe(onNext: { (data) in
				print(data!)
			}, onError: { (error) in
                UtilityHelper.presentAlertMessage("Errore", message: "Errore nell'inserimento di una variazione", viewController: self)
				print("Errore nell'inserimento di una variazione: \(error)")
			}, onCompleted: {
                UtilityHelper.presentAlertMessage("Congratulazioni", message: "Modifiche Avvenute", viewController: self)
				print("Completed")
			}, onDisposed: {
				print("Disposed")
			})
		}else{
			UtilityHelper.presentAlertMessage("Errore", message: "È necessario compilare tutti i campi relativi", viewController: self)
		}
	}
    

    
    func getUpdatesPayment(){
        if !emptyfieldExists() {
            selectedVariazione?.abi = Int(txtABI.text ?? "")
            selectedVariazione?.cab = Int(txtCAB.text ?? "")
            selectedVariazione?.cineu = Int(txtCinEu.text ?? "")
            selectedVariazione?.paese = txtPaese.text ?? ""
            selectedVariazione?.cinit = txtCinIT.text ?? ""
            selectedVariazione?.conto = txtContoCorrente.text ?? ""
            selectedVariazione?.istituto = txtIstituto.text ?? ""
            selectedVariazione?.cinbban = getBban()
            selectedVariazione?.ciniban = getIban()
            //update variazione
            repo.updateVariazione(Variazione: selectedVariazione!.varId!, byVariazione: selectedVariazione!)
        }
        
    }
    
    func getBban() -> String{
        var BBAN = ""
        var zeros = ""
        let cinIt = txtCinIT.text
        BBAN += cinIt!
        
        let ABI = txtABI.text
        zeros = hasFiveNumbers(Number: ABI!,size: 5)
        BBAN = zeros + ABI!
        
        let contoCorrente = txtContoCorrente.text
        zeros = hasFiveNumbers(Number: contoCorrente!,size: 12)
        BBAN = zeros + contoCorrente!
        
        return BBAN
    }
    func getIban() -> String{
        var IBAN = ""
        var zeros = ""
        let paese = txtPaese.text
        let cinEu = txtCinEu.text
        let cinIt = txtCinIT.text
        IBAN = paese! + cinEu! + cinIt!
        
        let ABI = txtABI.text
        zeros = hasFiveNumbers(Number: ABI!,size: 5)
        IBAN = zeros + ABI!
        
        let CAB = txtCAB.text
        zeros = hasFiveNumbers(Number: CAB!,size: 5)
        IBAN = zeros + CAB!
        
        let contoCorrente = txtContoCorrente.text
        zeros = hasFiveNumbers(Number: contoCorrente!,size: 12)
        IBAN = zeros + contoCorrente!
         
        
        return IBAN
    }
    
    func hasFiveNumbers(Number number:String, size:Int) -> String{
        if number.count>size{
            return ""
        }else{
            var zeros = ""
            for _ in 0...(size-number.count){
                zeros += "0"
            }
            return zeros
        }
    }
	
	func emptyfieldExists() -> Bool{
		var empty = false
		for c in 1...7{
			if let textfield = self.view.viewWithTag(c) as? UITextField{
                if textfield.text == "" {
                    textfield.shake()
                    textfield.highlightOnError()
                    empty = true
                }
			}
		}
		return empty
	}
	
	func deleteDelegate(){
		selectedVariazione?.hasDelegato = false
		loadRequest()
	}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: DELEGATE
    func saveDelegate(variazione: Variazione){
        self.repo.saveDelegate(Variazione: variazione)
        reloadData()
    }
    
    func prepareTipiPagamento(){
        let tipiPagamento = pagaRepo.getAllTipiPagamento()
        for tipoPagamento in tipiPagamento{
            tipologiePagamento.append(tipoPagamento.nome!)
        }
    }
    
    
    
    func reloadData () {
        self.variazioni = []
        self.variazioni = self.repo.getVariazioni()
        self.statiVars = self.getTipi()
        self.statiToString()
        if self.variazioni.count > 0 && self.isFirstTime == true{
            self.getVariazione(byID: self.statiVars[0].idVariazione!)
            let tipPag = pagaRepo.getNameTipoPagamento(byCode: variazioni[0].codtippag!)
            self.btnTipologiaPagamento.setTitle(tipPag!.nome!, for: .normal)
            self.btnCmbModalita.setTitle(variazioni[0].stato?.rawValue, for: .normal)
        }else{
         self.getVariazione(byID: self.selectedVariazione!.varId!)
            let tipPag = pagaRepo.getNameTipoPagamento(byCode: selectedVariazione!.codtippag!)
            self.btnTipologiaPagamento.setTitle(tipPag!.nome!, for: .normal)
            self.btnCmbModalita.setTitle(selectedVariazione!.stato?.rawValue, for: .normal)
        }

        self.setupStackButton()
        prepareTipiPagamento()
        self.populateView()
        // faccio questo perche se esiste gia una variazione è necessario che si sblocchi in caso di sm o it
        self.accountType(byState: variazioni[0].paese! )
    }
    
// passo anche il booleano del delegato perche arrivano i dati a caso e succede a volte che il delegato non ha nome o cognome o cf
// cosi evito di fare dei mischioni
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueDelegatoViewController"{
            let vc = segue.destination as! DelegatoViewController
            // non sono sicuro sia giusta
            vc.variazione = self.repo.getVariazione(byID: self.selectedVariazione!.varId!)
            vc.delegateIsNull = self.delegateIsNull
            vc.delegate = self
        }
    }
	
	
}
