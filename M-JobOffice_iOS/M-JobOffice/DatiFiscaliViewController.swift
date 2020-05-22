//
//  DatiFiscaliViewController.swift
//  M-JobOffice
//
//  Created by Stage on 09/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftSpinner
import MMDrawerController

class DatiFiscaliViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FamiliareDelegate, EditingDelegate {
    
    
    
	
	//MARK: VAR FOR CALL
	private let PERIODI = "periodi"
	private let ANNO = "anno"
	private let ENTI = "enti"
	private let ID_ENTE = "idEnte"
	private let IDGPX_DAC_ANAGFIS = "idGpxDACAnagfis"
	private let IDGPX_DACDET_ANAGFIS = "idGpxDACDetanagfis"
	private let ID_WORKFLOW_INSTANCE = "idWorkflowInstance"
	private let PERIODO = "periodo"
	private let ID_TO_UPLOAD = "idwkf"
	private let ESITO_CANC = "deldetrfisc"
	private let ESITO_EFFETT = "esito"
	private let ERRORE = "errMessage"
	private let RICHIESTA = "richiesta"
	private let ESITO_RICHIESTA = "richvar"
	
	//MARK: VAR
	var indexFamiliare = 0
	var isEdit = false
	var arrayPeriodi = [Periodo]()
	var arrayEnti = [Ente]()
	var downloadNewPeriodi = false
	var anno: Int?
	var periodoSelected: Periodo?
	var enteSelected: Ente?
	var richiesta: Richiesta?
	var initialSelection = 0
	var meseInizio = Int()
    var meseFine = Int()
	var numFamiliari = 0
	var selectedMembro: IndexPath?
	var delegate: EditingDelegate?
    var familiari = [Familiare]()
    var count = 0
    let familiareRepo = DatiFiscaliRepository()
    var familiare = Familiare()
	
	//MARK: OUTLETS
	@IBOutlet var heightToHide: NSLayoutConstraint!
	@IBOutlet var buttonMenu: BSDStackMenu!
	@IBOutlet var periodoPicker: UIButton!
	@IBOutlet var entePicker: UIButton!
	@IBOutlet var checkAliquota: CheckBox!
	@IBOutlet var checkBonus: CheckBox!
	@IBOutlet var checkDetrProdReddito: CheckBox!
	@IBOutlet var checkDetrFamNum: CheckBox!
	@IBOutlet var txtPercAliquota: UITextField!
	@IBOutlet var txtTipBonus: UITextField!
	@IBOutlet var txtReddito: UITextField!
	@IBOutlet var txtPercFamNum: UITextField!
	@IBOutlet var tableViewMember: UITableView!
	@IBOutlet var pickerMeseInizio: UIButton!
	@IBOutlet var annoPicker: UIButton!
	@IBOutlet var pickerMeseFine: UIButton!
	
	//MARK: OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableViewMember.delegate = self
		self.tableViewMember.dataSource = self
		
		self.tableViewMember.tableFooterView = UIView(frame: CGRect.zero)
		self.tableViewMember.tableFooterView?.isHidden = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
        if count == 0{
            getPeriodi()
            count += 1
        }else{
            familiari = familiareRepo.getFamiliari()
            tableViewMember.reloadData()
        }
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	//MARK: CHIAMATE
	func getPeriodi() {
		let _ = SwiftSpinner.show("Ricerca detrazioni...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		let _ = WebService.sharedInstance.getPeriodi().asObservable().subscribe(onNext: { (data) in
			if let dict = data as? Dictionary<String,Any> {
				if let dataDict = dict[self.PERIODI] as? [Dictionary<String,Any>] {
					for json in dataDict {
						let periodo = Periodo(by: json)
						self.arrayPeriodi.append(periodo)
					}
					if !self.arrayPeriodi.isEmpty {
						self.periodoSelected = self.arrayPeriodi[0]
						
					}
					
					self.getEnti()
				}
			}
		}, onError: { (error) in
			print(error)
			ErrorManager.presentError(error: error as NSError, vc: self)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("completed")
		}) {
			print("disposed")
		}
	}
	
	func getEnti() {
		var params = Dictionary<String,Any>()
		if !self.arrayPeriodi.isEmpty {
			params[ANNO] = periodoSelected!.annoFiscale!
			downloadNewPeriodi = false
		} else {
			downloadNewPeriodi = true
			params[ANNO] = DateHelper.getCurrentYear()
		}
		let _ = WebService.sharedInstance.getEnti(params).asObservable().subscribe(onNext: { (data) in
			if let dict = data as? Dictionary<String,Any> {
				if let dataDict = dict[self.ENTI] as? [Dictionary<String,Any>] {
					var array = [Ente]()
					for json in dataDict {
						let ente = Ente(by: json)
						array.append(ente)
					}
					self.arrayEnti = array
					if !self.arrayEnti.isEmpty {
						self.enteSelected = self.arrayEnti[0]
						self.entePicker.setTitle("\(self.arrayEnti[0].des_ente!)", for: .normal)
						self.periodoPicker.setTitle("\( self.periodoSelected!.annoFiscale!) - \(self.enteSelected!.des_ente!)", for: .normal)
					}
					if self.downloadNewPeriodi {
						self.getNewPeriodi(id: self.arrayEnti[0].id_ente!)
					}
					self.getDetrazione()
				}
			}
		}, onError: { (error) in
			print(error)
			ErrorManager.presentError(error: error as NSError, vc: self)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("completed")
		}){
			print("disposed")
		}
	}
	
	func getNewPeriodi(id: Int) {
		var params = Dictionary<String,Any>()
		params = Periodo.setParamsForCall(id: id)
		let _ = WebService.sharedInstance.getNuoviPeriodi(params).asObservable().subscribe(onNext: { (data) in
			
			if let dict = data as? Dictionary<String,Any> {
				let periodo = Periodo(by: dict)
				self.arrayPeriodi.append(periodo)
			}
			self.periodoSelected = self.arrayPeriodi[0]
		}, onError: { (error) in
			print(error)
			ErrorManager.presentError(error: error as NSError, vc: self)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("completed")
		}) {
			print("disposed")
		}
	}
	
	func getDetrazione() {
		var params = Dictionary<String,Any>()
		params[ID_ENTE] = enteSelected?.id_ente!
		params[IDGPX_DAC_ANAGFIS] = periodoSelected?.idGpxDACAnagfis!
		params[IDGPX_DACDET_ANAGFIS] = periodoSelected?.idGpxDACDetanagfis!
		params[ID_WORKFLOW_INSTANCE] = periodoSelected?.idWorkflowInstance!
        print("parametri che sto chiedendo alla chiamata getdetrazione: ", params)

        
		let _ = WebService.sharedInstance.getDettaglioDetrazione(params).asObservable().subscribe(onNext: { (data) in
			if let dict = data as? Dictionary<String,Any> {
				print(dict)
				if let json = dict[self.PERIODO] as? Dictionary<String, Any> {
					self.richiesta = Richiesta(by: json)
					self.numFamiliari = self.richiesta!.familiari.count - 1
					self.tableViewMember.reloadData()
					self.setupStackButton()
                    self.familiareRepo.deleteAllFamiliari()
                    self.familiari = self.richiesta!.familiari
                    // funzione che cancella e salva sul db
                    for familiare in self.richiesta!.familiari
                    {
                        self.familiareRepo.insertFamiliare(byFamiliare: familiare)
                    }
				}
			}
			self.setOutlets()
			self.tableViewMember.reloadData()
			SwiftSpinner.hide()
		}, onError: { (error) in
			print(error)
			ErrorManager.presentError(error: error as NSError, vc: self)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("completed")
		}) {
			print("disposed")
		}
	}
	
	func uploadDetrazione() {
		var params = Dictionary<String,Any>()
        
        richiesta?.mese_inizio = self.meseInizio
        richiesta?.mese_fine = self.meseFine
        richiesta?.anno_fiscale = self.periodoSelected!.annoFiscale!
        var tmp = Double(self.txtPercAliquota.text ?? "0")
        richiesta?.prc_aliq_fissa = tmp
        richiesta?.flg_bonus_prod_reddito = self.checkDetrProdReddito.checked
        richiesta?.flg_fam_numerose = self.checkDetrFamNum.checked
        richiesta?.flg_aliq_fissa = self.checkAliquota.checked
        richiesta?.flg_bonus = self.checkBonus.checked
        tmp = Double(self.txtPercFamNum.text ?? "0")
        richiesta?.prc_fam_numerose = tmp
        richiesta?.tip_bonus = self.txtTipBonus.text
        tmp = Double(self.txtReddito.text ?? "0")
        richiesta?.imp_reddult = tmp
        
        
        var componenti = [Familiare]()
        familiareRepo.getFamiliari().forEach { elem in
            componenti.append(elem)
        }
        richiesta?.familiari = componenti
        
        
        params[RICHIESTA] = richiesta?.getParams()
        print("DETRAZIONE CHE MANDO SU AL SERVER: ", richiesta?.getParams())

        
		let _ = SwiftSpinner.show("Carico la richiesta...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		let _ = WebService.sharedInstance.addDetrazione(params).asObservable().subscribe(onNext: { (data) in
			if let dict = data as? Dictionary<String,Any> {
				if let risp = dict[self.ESITO_RICHIESTA] as? [Dictionary<String,Any>] {
					if let esito = risp[0][self.ESITO_EFFETT] as? Bool {
						if esito {
							SuccessView.show(onViewController: self, isSucces: true)
							self.tableViewMember.reloadData()
						} else {
							SuccessView.show(onViewController: self, isSucces: false)
						}
					}
				}
			}
			
			SwiftSpinner.hide()
		}, onError: { (error) in
			print(error)
			ErrorManager.presentError(error: error as NSError, vc: self)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("completed")
		}) {
			print("disposed")
		}
	}
	
	func deleteRichiestaServer() {
		var params = Dictionary<String,Any>()
		if richiesta != nil {
			params[ID_TO_UPLOAD] = periodoSelected!.idWorkflowInstance
			let _ = SwiftSpinner.show("Cancello la richiesta...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
			let _ = WebService.sharedInstance.deleteDetrazione(params).asObservable().subscribe(onNext: { (data) in
				if let dict = data as? Dictionary<String,Any> {
					print(dict)
					if let json = dict[self.ESITO_CANC] as? [Dictionary<String, Any>] {
						if let esito = json[0][self.ESITO_EFFETT] as? Bool {
							if esito {
								UtilityHelper.presentAlertMessage("Richiesta eliminata", message: "la tua richiesta è stata eliminata", viewController: self)
								self.getPeriodi()
							} else {
								UtilityHelper.presentAlertMessage("Errore", message: "l'eliminazione non è andata a buon fine: \(json[0][self.ERRORE] as! String)", viewController: self)
							}
						}
					}
				}
				self.setOutlets()
				self.tableViewMember.reloadData()
				SwiftSpinner.hide()
			}, onError: { (error) in
				print(error)
				ErrorManager.presentError(error: error as NSError, vc: self)
				SwiftSpinner.hide()
			}, onCompleted: {
				print("completed")
			}) {
				print("disposed")
			}
			
			
		} else {
			UtilityHelper.presentAlertMessage("Nessuna richiesta", message: "attualmente non risultano richieste da eliminare", viewController: self)
		}
	}
	
	
	
	
	
	//MARK: PICKERS
	@IBAction func pickInitMonth(_ sender: UIButton) {
		var array = DateHelper.getArrayMonths()
		array = array.map({ (month) -> String in
			return month.uppercased()
		})
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
			self.meseInizio = selectedIndex
			sender.setTitle(selectedValue as? String, for: .normal)
			if let index = array.index(of: self.pickerMeseFine.title(for: .normal)!) {
				if index < self.meseInizio {
					self.pickerMeseFine.setTitle(array[self.meseInizio], for: .normal)
				}
			} else {
				self.pickerMeseFine.setTitle(array[self.meseInizio], for: .normal)
			}
			self.pickerMeseFine.isUserInteractionEnabled = true
			self.pickerMeseFine.isEnabled = true
			
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	
	@IBAction func pickFinalMonth(_ sender: UIButton) {
		var array = DateHelper.getArrayMonths()
		array = array.map({ (month) -> String in
			return month.uppercased()
		})
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
            self.meseFine = selectedIndex
			for i in 0...array.count-1 {
				if array[i] == selectedValue as! String {
					if i < self.meseInizio {
						sender.setTitle(array[self.meseInizio], for: .normal)
					} else {
						sender.setTitle(selectedValue as? String, for: .normal)
					}
				}
			}
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	
	
	@IBAction func pickYear(_ sender: UIButton) {
		let years = (DateHelper.getCurrentYear() - 15)...(DateHelper.getCurrentYear() + 2)
		let array: [Int] = years.reversed()
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
			sender.setTitle(String(describing: selectedValue as! Int), for: .normal)
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	
	
	
	
	@IBAction func selectPeriodo(_ sender: UIButton) {
		if (!self.arrayPeriodi.isEmpty){
			let picker = ActionSheetStringPicker(title: "Scegli valore", rows: self.arrayPeriodi.map({ (periodo) -> Int in
				periodo.annoFiscale!
			}), initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
				
				sender.setTitle("\(String(describing: selectedValue as? Int != nil ? (selectedValue as! Int) : 0000))",for: .normal)
				self.arrayPeriodi.forEach({ (periodo) in
					if periodo.annoFiscale! == selectedValue as? Int {
						self.periodoSelected = periodo
					}
				})
				let _ = SwiftSpinner.show("Ricerca detrazioni", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
				self.getEnti()
			}, cancel: nil , origin: sender)
			picker?.hideCancel = true
			picker?.show()
		}
	}
	
	
	
	@IBAction func selectEnte(_ sender: UIButton) {
		if (!self.arrayEnti.isEmpty){
			let picker = ActionSheetStringPicker(title: "Scegli valore", rows: self.arrayEnti.map({ (ente) -> String in
				ente.des_ente!
			}), initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
				
				sender.setTitle("\(String(describing: selectedValue as? String != nil ? (selectedValue as! String) : ""))",for: .normal)
				self.arrayEnti.forEach({ (ente) in
					if ente.des_ente! == selectedValue as? String {
						self.enteSelected = ente
					}
				})
				let _ = SwiftSpinner.show("Ricerca detrazioni", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
				self.getDetrazione()
			}, cancel: nil , origin: sender)
			picker?.hideCancel = true
			picker?.show()
		}
	}
	
	//MARK: METHOD OF ADD COMPONENT
	func addMemberToTable() {
		let vc = storyboard?.instantiateViewController(withIdentifier: "ComponenteNucleoViewController") as? ComponenteNucleoViewController
		let navigation = UINavigationController(rootViewController: vc!)
		navigation.isNavigationBarHidden = true
		//selectedMembro = indexPath
		vc?.delegateFamiglia = self
		vc?.closer = self
		if IS_IPAD {
			mm_drawerController.showDetailViewController(navigation, sender: nil)
		} else {
			self.navigationController?.pushViewController(vc!, animated: true)
		}
		buttonMenu.closeMenu()
		setEdit()
		
//		present(navigation, animated: true , completion: nil)
	}
	
	//MARK: SETTLERS
	func setOutlets() {
		if richiesta != nil {
			self.checkAliquota.checked = richiesta!.flg_aliq_fissa!
			self.checkAliquota.setImage(self.checkAliquota.checked ? #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected"), for: .normal)
			self.checkBonus.checked = richiesta!.flg_bonus!
			self.checkBonus.setImage(self.checkBonus.checked ? #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected"), for: .normal)
			self.checkDetrProdReddito.checked = richiesta!.flg_bonus_prod_reddito!
			self.checkDetrProdReddito.setImage(self.checkDetrProdReddito.checked ? #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected"), for: .normal)
			self.checkDetrFamNum.checked = richiesta!.flg_fam_numerose!
			self.checkDetrFamNum.setImage(self.checkDetrFamNum.checked ? #imageLiteral(resourceName: "check-selected") : #imageLiteral(resourceName: "check-deselected"), for: .normal)
			self.annoPicker.setTitle(String(describing: richiesta!.anno_fiscale!), for: .normal)
			self.pickerMeseInizio.setTitle(DateHelper.getMonthBy(number: richiesta!.mese_inizio!), for: .normal)
			self.pickerMeseFine.setTitle(DateHelper.getMonthBy(number: richiesta!.mese_fine!), for: .normal)
			self.txtPercAliquota.text = "\(String(describing: richiesta!.prc_aliq_fissa!)) %"
			self.txtTipBonus.text = String(describing: richiesta!.tip_bonus!)
			self.txtReddito.text = String(describing: richiesta!.imp_reddult!)
			self.txtPercFamNum.text = "\(String(describing: richiesta!.prc_fam_numerose!)) %"
		}
		else {
			
		}
	}
	
	func setupStackButton(){
		
		var buttons = [BSDStackMenuCell]()
		
		let btnDeleteDelegate = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_delete") , title: "Elimina richiesta", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			self.deleteRichiesta()
		}
		let btnAddRequest = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_add_stack"), title: "Aggiungi richiesta", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			self.salvaDetrazione()
		}
		let btnAddComponent = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "add_family"), title: "Aggiungi componente", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			self.addMemberToTable()
		}
		if periodoSelected!.idWorkflowInstance! <= 0 {
			buttons = [btnAddRequest, btnAddComponent]
		} else {
			buttons = [btnAddRequest, btnDeleteDelegate, btnAddComponent]
		}
		
		
		buttonMenu.initialize(by: buttons)
	}
	
	func setEdit() {
		if isEdit {
			isEdit = false
		}
	}
	
	
	
	 func deleteRichiesta() {
		deleteRichiestaServer()
	}
	
	func salvaDetrazione() {
		richiesta!.anno_fiscale = Int(annoPicker.title(for: .normal)!)
		richiesta!.data_richiesta = DateHelper.getCurrentDateCustomed()
		richiesta!.flg_aliq_fissa = checkAliquota.checked
		richiesta!.flg_bonus = checkBonus.checked
		richiesta!.flg_bonus_prod_reddito = checkDetrProdReddito.checked
		richiesta!.flg_fam_numerose = checkDetrFamNum.checked
		richiesta!.imp_reddult = Double(txtReddito.text!)
		
		richiesta!.tip_bonus = txtTipBonus.text
		richiesta!.prc_aliq_fissa = Double(txtPercAliquota!.text!.replacingOccurrences(of: " %", with: ""))
		richiesta!.prc_fam_numerose = Double(txtPercFamNum!.text!.replacingOccurrences(of: " %", with: ""))
		uploadDetrazione()
	}
	
	
	
	
	//MARK: TABLEVIEW
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		cell = (tableView.dequeueReusableCell(withIdentifier: "cellFamiliare") as? BaseTableViewCell)!
		if richiesta != nil {
			
            (cell as? BaseTableViewCell)?.initialize(familiare: self.familiari[indexPath.row])
			
		} else {
			(cell as? BaseTableViewCell)?.initialize()
		}
		selectedMembro = indexPath
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		isEdit = true
		let vc = storyboard?.instantiateViewController(withIdentifier: "ComponenteNucleoViewController") as? ComponenteNucleoViewController
		let navigation = UINavigationController(rootViewController: vc!)
		navigation.isNavigationBarHidden = true
		//selectedMembro = indexPath
		vc?.delegateFamiglia = self
		indexFamiliare = indexPath.row
		vc!.closer = self
        vc?.familiare = self.familiari[indexPath.row]
		if IS_IPAD {
			mm_drawerController.showDetailViewController(navigation, sender: nil)
		} else {
			self.navigationController?.pushViewController(vc!, animated: true)
		}
		buttonMenu.closeMenu()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.familiari.count
	}
	
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if isEdit {
			close()
			isEdit = false
		}
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
			numFamiliari -= 1
			self.richiesta?.familiari.remove(at: indexPath.row)
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .left)
			tableView.endUpdates()
		}
	}
	
	//MARK: DELEGATE
	func close() {
		let vc = storyboard?.instantiateViewController(withIdentifier: "empty") as? EmptyViewController
		if IS_IPAD {
			mm_drawerController.showDetailViewController(vc!, sender: nil)
		} else {
			self.navigationController?.popViewController(animated: true)
		}
	}      
	
	func saveFamiliare(familiare: Familiare) {
        familiareRepo.insertOrUpdate(byFamiliare: familiare)
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveFamiliare(ComponentiNucleoANF: FamiliareANF) {/*non usata qui*/}
}
protocol EditingDelegate {
	//questo delegate si occupa di chiudere il detail se viene eliminato il familiare durante l'editing
	func close()
}
