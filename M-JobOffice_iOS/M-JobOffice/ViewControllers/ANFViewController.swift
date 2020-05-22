//
//  ANFViewController.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 03/02/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftSpinner
import MMDrawerController

class ANFViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, FamiliareDelegate, EditingDelegate {
    
    
    
	//MARK: CONSTANT
	private let PERIODI = "periodi"
	private let ANNO = "anno"
	private let ENTI = "enti"
	private let ID_ENTE = "idEnte"
	private let IDGPX_DAC_NUCFAM = "idGpxDACNucfam"
	private let ID_WORKFLOW_INSTANCE = "idWorkflowInstance"
	private let PERIODO = "periodo"
	private let ID_TO_UPLOAD = "idwkf"
	private let ESITO_CANC = "delvar"
	private let ESITO_EFFETT = "esito"
	private let ERRORE = "errMessage"
	private let RICHIESTA = "richiesta"
	private let ESITO_RICHIESTA = "richanf"
    let componentiRepo = ComponentiNucleoRepository()
    let periodiRepo = PeriodiRepository()
    let entiRepo = EntiRepository()
    let richiestaRepo = RichiestaRepository()
    


    //MARK: Outlets
	@IBOutlet var annoFinePicker: UIButton!
	@IBOutlet var meseFinePicker: UIButton!
	@IBOutlet var annoInizioPicker: UIButton!
	@IBOutlet var meseInizioPicker: UIButton!
	@IBOutlet var buttonMenu: BSDStackMenu!
	@IBOutlet weak var componentiTableView: UITableView!
    @IBOutlet weak var periodoPicker: UIButton!
	@IBOutlet var entePicker: UIButton!
	@IBOutlet var hideView: UIView!
	
	//MARK: vars
	var initYear = Int()
	var meseInizio = Int()
    var meseFine = Int()
	var downloadNewPeriodi = false
	var enteSelected: Ente?
	var initialSelection = 0
	var arrayEnti = [Ente]()
	var arrayPeriodi = [PeriodoANF]()
	var periodoSelected: PeriodoANF?
    var richiestaToUpload: RichiestaANF?
	var indexFamiliare = 0
	var isEdit = false
	var numFamiliari = 0
	var richiesta: RichiestaANF?
    var detrazioneANF: DetrazioneANF?
    var componentiFam = [FamiliareANF]()
    var count = 0
    var componenteFam = FamiliareANF()

	
	//MARK: OVERRIDE
	override func viewDidLoad() {
		super.viewDidLoad()
		self.componentiTableView.tableFooterView = UIView(frame: CGRect.zero)
		self.componentiTableView.tableFooterView?.isHidden = true
		self.componentiTableView.dataSource = self
		self.componentiTableView.delegate = self
        
        
	}
	
	override func viewDidAppear(_ animated: Bool) {
		// faccio la getAll
        if count == 0{
            getPeriodi()
            
            count += 1
        }else{
            //getNewPeriodi non funziona per far la get di una richiesta non approvata
            //getNewPeriodi(id: periodoSelected?.idEnte ?? -1)
            componentiFam = componentiRepo.getComponenti()
            componentiTableView.reloadData()
        }
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: CHIAMATE
	func getPeriodi() {
		let _ = SwiftSpinner.show("Ricerca ANF...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		let _ = WebService.sharedInstance.getPeriodiANF().asObservable().subscribe(onNext: { (data) in
			if let dict = data as? Dictionary<String,Any> {
				if let dataDict = dict[self.PERIODI] as? [Dictionary<String,Any>] {
					for json in dataDict {
						let periodo = PeriodoANF(by: json)
						self.arrayPeriodi.append(periodo)
					}
					if !self.arrayPeriodi.isEmpty {
						self.periodoSelected = self.arrayPeriodi[0]
					}
					self.getEnti()
				}
                
                //metto i dati in periodi repo
                self.periodiRepo.deleteAll()
                for per in self.arrayPeriodi
                {
                    self.periodiRepo.insertPeriodoANF(by: per)
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
			params[ANNO] = periodoSelected!.annoInizio!
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
					}
					if self.downloadNewPeriodi {
						self.getNewPeriodi(id: self.arrayEnti[0].id_ente!)
					} else {
						self.periodoPicker.setTitle("\( self.periodoSelected!.annoInizio!) - \(self.enteSelected!.des_ente!)", for: .normal)
						self.getDetrazione()
					}
                    
                    //metto i dati in periodi repo
                    self.entiRepo.deleteAll()
                    for ente in self.arrayEnti
                    {
                        self.entiRepo.insertEnte(by: ente)
                    }
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
	
	func getDetrazione() {
		var params = Dictionary<String,Any>()
		params[ID_ENTE] = enteSelected?.id_ente!
		params[IDGPX_DAC_NUCFAM] = periodoSelected?.idGpxDACNucFam ?? -1
		params[ID_WORKFLOW_INSTANCE] = periodoSelected?.idWorkflowInstance ?? -1
        print("parametri che sto chiedendo alla chiamata getdetrazione: ", params)
        
        if((periodoSelected?.idWorkflowInstance ?? -1) > 0) {

            
            // TODO
            //qui ci va la chiamata nuova per ricevere il periodo che dev'essere accettato
            
            let _ = WebService.sharedInstance.getDettaglioDetrazione(params).asObservable().subscribe(onNext: { (data) in
                if let dict = data as? Dictionary<String,Any> {
                   
                    if let json = dict[self.PERIODO] as? Dictionary<String, Any> {
                        self.richiesta = RichiestaANF(by: json)
                        self.numFamiliari = self.richiesta!.familiari.count - 1
                        self.componentiTableView.reloadData()
                        self.setupStackButton()
                        self.meseInizio = self.richiesta!.mese_inizio! - 1
                        self.meseFine = self.richiesta!.mese_fine! - 1
                        self.componentiRepo.deleteAllComponenti()
                        self.componentiFam = self.richiesta!.familiari
                        for componenteANF in self.richiesta!.familiari
                        {
                            self.componentiRepo.insertComponente(byComponente: componenteANF)
                        }
                                            
                        
                        
                        
                        print("PARAMETRI RICHIESTI DALLA NUOVA CHIAMATA: ", self.richiesta?.getParams() ?? "")

                        //self.richiestaRepo.deleteAll()
                        //self.richiestaRepo.insertRichiesta(by: self.richiesta!)
                        
                        //qui fa la chiamata che gli restituisce tutti i dati da mostrare nella schermata ANF
                        //a seconda del periodo selezionato farà una chiamata con parametri diversi
                        //e la risposta della chiamata saranno i valori da mostrare nel resto della schermata
                        
                    }
                }
                self.setOutlets()
                self.componentiTableView.reloadData()
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
            let _ = WebService.sharedInstance.getDettaglioDetrazioneANF(params).asObservable().subscribe(onNext: { (data) in
                if let dict = data as? Dictionary<String,Any> {
                   
                    if let json = dict[self.PERIODO] as? Dictionary<String, Any> {
                        self.richiesta = RichiestaANF(by: json)
                        self.numFamiliari = self.richiesta!.familiari.count - 1
                        self.componentiTableView.reloadData()
                        self.setupStackButton()
                        self.meseInizio = self.richiesta!.mese_inizio! - 1
                        self.meseFine = self.richiesta!.mese_fine! - 1
                        self.componentiRepo.deleteAllComponenti()
                        self.componentiFam = self.richiesta!.familiari
                        for componenteANF in self.richiesta!.familiari
                        {
                            self.componentiRepo.insertComponente(byComponente: componenteANF)
                        }
                                            
                        
                        
                        
                        print("PARAMETRI RICHIESTI: ", self.richiesta?.getParams() ?? "")

                        //self.richiestaRepo.deleteAll()
                        //self.richiestaRepo.insertRichiesta(by: self.richiesta!)
                        
                        //qui fa la chiamata che gli restituisce tutti i dati da mostrare nella schermata ANF
                        //a seconda del periodo selezionato farà una chiamata con parametri diversi
                        //e la risposta della chiamata saranno i valori da mostrare nel resto della schermata
                        
                    }
                }
                self.setOutlets()
                self.componentiTableView.reloadData()
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
	}
	
	func getNewPeriodi(id: Int) {
		var params = Dictionary<String,Any>()
		params = PeriodoANF.setParamsForCall(id: id)
		let _ = WebService.sharedInstance.getNuoviPeriodiANF(params).asObservable().subscribe(onNext: { (data) in
			
			if let dict = data as? Dictionary<String,Any> {
				let periodo = PeriodoANF(by: dict)
				self.arrayPeriodi.append(periodo)
			}
			self.periodoSelected = self.arrayPeriodi[0]
			self.getDetrazione()
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
        
        var per = PeriodoANF()
        per.idGpxDACNucFam = richiesta?.id_nucleo
        per.idEnte = richiesta?.id_ente
        per.annoInizio = richiesta?.anno_inizio
        per.annoFine = richiesta?.anno_fine
        per.meseInizio = richiesta?.mese_inizio
        per.meseFine = richiesta?.mese_fine

        richiesta?.familiari = self.componentiRepo.getComponenti()
		params[RICHIESTA] = richiesta?.getParams()
        //print("PARAMETRI CHE ANDRANNO IN UPLOAD DETRAZIONE", params)
        
        let _ = SwiftSpinner.show("Carico la richiesta...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		let _ = WebService.sharedInstance.addDetrazioneANF(params).asObservable().subscribe(onNext: { (data) in

			if let dict = data as? Dictionary<String,Any> {
				if let risp = dict[self.ESITO_RICHIESTA] as? [Dictionary<String,Any>] {
					if let esito = risp[0][self.ESITO_EFFETT] as? Bool {
                        
						if esito {
							SuccessView.show(onViewController: self, isSucces: true)
						} else {
							SuccessView.show(onViewController: self, isSucces: false)
						}
                        
                        //controllo rispetto a periodoSelected, se il periodo selezionato
                        //non è stato modificato non aggiungo un record identico
                        if !(self.periodoSelected?.annoInizio == per.annoInizio
                            && self.periodoSelected?.annoFine == per.annoFine
                            && self.periodoSelected?.meseInizio == (per.meseInizio ?? -1)+1
                            && self.periodoSelected?.meseFine == (per.meseFine ?? -1)+1
                            && self.periodoSelected?.idEnte == per.idEnte
                            && self.periodoSelected?.idGpxDACNucFam == per.idGpxDACNucFam)
                        {
                            per.idWorkflowInstance = self.periodoSelected!.idWorkflowInstance! + Int.random(in: 2 ..< 10000)
                            let number = self.periodoSelected!.idGpxDACNucFam
                            
                            per.idGpxDACNucFam = number
                            self.periodiRepo.insertPeriodoANF(by: per)
                            self.arrayPeriodi.append(per)
                        }
						self.componentiTableView.reloadData()
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
			let _ = SwiftSpinner.show("Cancello...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
			let _ = WebService.sharedInstance.deleteDetrazioneANF(params).asObservable().subscribe(onNext: { (data) in
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
				self.componentiTableView.reloadData()
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
    
    
    func uploadComponentiFam() {
        /*
        var params = Dictionary<String,Any>()
        let _ = SwiftSpinner.show("Carico la richiesta...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
        var componenti = [Dictionary<String,Any>]()
        
        componentiRepo.getComponenti().forEach { elem in
            componenti.append(elem.getParams())
        }
        
        params = Dictionary<String,Any>()

        params[RICHIESTA] = componenti
        print("RISULTATO FINALE DEI PARAMS: ", params)
        
        
        let _ = WebService.sharedInstance.setComponentiNucleoFam(params).asObservable().subscribe(onNext: { (data) in
            if let dict = data as? Dictionary<String,Any> {
                
                if let risp = dict[self.ESITO_RICHIESTA] as? [Dictionary<String,Any>] {
                    if let esito = risp[0][self.ESITO_EFFETT] as? Bool {
                        if esito {
                            print("RICHIESTA DEI COMPONENTI FAM ANDATA BENE", params)
                            SuccessView.show(onViewController: self, isSucces: true)
                        } else {
                            SuccessView.show(onViewController: self, isSucces: false)
                        }
                        self.componentiTableView.reloadData()
                    }
                }
            }
            print("RICHIESTA DEI COMPONENTI FAM ANDATA BENE")
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
 */
    }
    
    
    
    
    
    
    
    
    
    
    
    /*
     la funzione da cui devo prendere spunto è questa
     
     
     
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
     
     */
    
    
    
    
    
    
    
	
	//MARK: PICKERS
	@IBAction func selectPeriodo(_ sender: UIButton) {
		if (!self.arrayPeriodi.isEmpty){
			let picker = ActionSheetStringPicker(title: "Scegli valore", rows: self.arrayPeriodi.map({ (periodo) -> Int in
				
				periodo.annoInizio ?? 0
			}), initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
                //controllo da cambiare perchè prima metteva 0 ovunque
				if (selectedValue as! Int) != 0 {
					sender.setTitle("\(String(describing: selectedValue as? Int != nil ? (selectedValue as! Int) : 0000))",for: .normal)
				} else {
					sender.setTitle("Periodo non specificato", for: .normal)
				}
				self.arrayPeriodi.forEach({ (periodo) in
					if periodo.annoInizio! as? Int == selectedValue as? Int {
						self.periodoSelected = periodo
					}
				})
				let _ = SwiftSpinner.show("Ricerca ANF...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
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
			picker?.show()
		}
	}
	//var isSameYear = false
	@IBAction func pickInitMonth(_ sender: UIButton) {
		var array = DateHelper.getArrayMonths()
		array = array.map({ (month) -> String in
			return month.uppercased()
		})
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
			self.meseInizio = selectedIndex
			sender.setTitle(selectedValue as? String, for: .normal)
			if Int(self.annoInizioPicker.title(for: .normal)!) == Int(self.annoFinePicker.title(for: .normal)!) {
				if let index = array.index(of: self.meseFinePicker.title(for: .normal)!) {
					if index < self.meseInizio {
						self.meseFinePicker.setTitle(array[self.meseInizio], for: .normal)
					}
				} else {
					self.meseFinePicker.setTitle(array[self.meseInizio], for: .normal)
				}
//				self.isSameYear = true
			}
//			self.meseFinePicker.isUserInteractionEnabled = true
//			self.meseFinePicker.isEnabled = true
			
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	
	@IBAction func pickFinalMonth(_ sender: UIButton) {
		
		var array = DateHelper.getArrayMonths()
		array = array.map({ (month) -> String in
			return month.uppercased()
		})
		if isSameYear() {
			array = array.filter({ (element) -> Bool in
				let index = array.index(of: element)      //se è l'anno iniziale è uguale al finale(ci troviamo nello stesso anno) i mesi finali saranno quelli successivi al quello iniziale scelto
				return index! >= self.meseInizio
			})
		}
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
            self.meseFine = selectedIndex
			sender.setTitle(selectedValue as? String, for: .normal)
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	

	@IBAction func pickInitYear(_ sender: UIButton) {
		let years = (DateHelper.getCurrentYear() - 15)...(DateHelper.getCurrentYear() + 2)
		let array: [Int] = years.reversed()
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
			self.initYear = selectedIndex
			sender.setTitle(String(describing: selectedValue as! Int), for: .normal)
			if let index = array.index(of: Int(self.annoFinePicker.title(for: .normal)!)!) {
				if index > self.initYear {
					self.annoFinePicker.setTitle(String(describing: array[self.initYear]), for: .normal)
//					self.isSameYear = true
				}
			}
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	
	@IBAction func pickFinalYear(_ sender: UIButton) {
		let inizio = Int(annoInizioPicker.title(for: .normal)!)
		let years = inizio!...(DateHelper.getCurrentYear() + 2)
		
		let array: [Int] = years.reversed()
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
			self.initYear = selectedIndex
			sender.setTitle(String(describing: selectedValue as! Int), for: .normal)
//			self.isSameYear = false
			if let index = array.index(of: Int(self.annoFinePicker.title(for: .normal)!)!) {
				if index < self.initYear {
					sender.setTitle(String(describing: array[self.initYear]), for: .normal)
//					self.isSameYear = true
				}
			}
			if self.isSameYear() {
				if DateHelper.getNumberBy(month: self.meseFinePicker.title(for: .normal)!) < DateHelper.getNumberBy(month: self.meseInizioPicker.title(for: .normal)!) {
					self.meseFinePicker.setTitle(self.meseInizioPicker.title(for: .normal)!, for: .normal)
				}
			}
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	
	
	
	//MARK: SETTLERS
	func setOutlets() {
		if richiesta != nil {
			meseInizioPicker.setTitle("\(DateHelper.getMonthBy(number: richiesta!.mese_inizio!))", for: .normal)
			meseFinePicker.setTitle("\(DateHelper.getMonthBy(number: richiesta!.mese_fine!))", for: .normal)
			annoFinePicker.setTitle("\(richiesta!.anno_fine!)", for: .normal)
			annoInizioPicker.setTitle("\(richiesta!.anno_inizio!)", for: .normal)
		}
	}
	
	func setupStackButton(){
		
		var buttons = [BSDStackMenuCell]()
		
		let btnDeleteDelegate = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_delete") , title: "Elimina richiesta", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			self.deleteRichiesta()
		}
		let btnAddRequest = BSDStackMenuCell.getNib(by: self, on: #imageLiteral(resourceName: "ic_add_stack"), title: "Aggiungi richiesta", backgroundColor: UIColor(red:0.37, green:0.57, blue:0.21, alpha:1.00)) {
			self.salvaDetrazione()
            self.updateComponentiFam()
            //print("NESSUN ERRORE IN AGGIUNGI RICHIESTA ")
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
	
	
	func isSameYear() -> Bool {
		return Int(self.annoFinePicker.title(for: .normal)!) == Int(self.annoInizioPicker.title(for: .normal)!)
	}
	//MARK: BSDMENU METHODS
	func deleteRichiesta() {
		deleteRichiestaServer()
	}
	
	func salvaDetrazione() {
		richiesta!.anno_inizio = Int(annoInizioPicker.title(for: .normal)!)
		richiesta!.data_richiesta = DateHelper.getCurrentDateCustomed()
		richiesta!.anno_fine = Int(annoFinePicker.title(for: .normal)!)
		richiesta!.mese_fine = Int(meseFinePicker.title(for: .normal)!)
		richiesta!.mese_inizio = Int(meseInizioPicker.title(for: .normal)!)
		uploadDetrazione()
	}
    
    func updateComponentiFam() {
        //print("METODO UPDATE COMPONENTI FAM")
        uploadComponentiFam()
    }
	
	func addMemberToTable() {
		let vc = storyboard?.instantiateViewController(withIdentifier: "ComponenteANFViewController") as? ComponenteANFViewController
		let navigation = UINavigationController(rootViewController: vc!)
		navigation.isNavigationBarHidden = true
		//selectedMembro = indexPath
		vc?.delegateFamiglia = self
		//indexFamiliare = indexPath.row
		vc!.closer = self
		if IS_IPAD {
			mm_drawerController.showDetailViewController(navigation, sender: nil)
		} else {
			self.navigationController?.pushViewController(vc!, animated: true)
		}
		buttonMenu.closeMenu()
		setEdit()
	}
	
	//MARK: TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		cell = (tableView.dequeueReusableCell(withIdentifier: "cellFamiliare") as? BaseTableViewCell)!
		if richiesta != nil {
            
             
            (cell as? BaseTableViewCell)?.initializeANF(familiareANF: self.componentiFam[indexPath.row])
			
		} else {
			(cell as? BaseTableViewCell)?.initializeANF() 
		}
		//selectedMembro = indexPath
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		isEdit = true
		let vc = storyboard?.instantiateViewController(withIdentifier: "ComponenteANFViewController") as? ComponenteANFViewController
		let navigation = UINavigationController(rootViewController: vc!)
		navigation.isNavigationBarHidden = true
		//selectedMembro = indexPath
		vc?.delegateFamiglia = self
		indexFamiliare = indexPath.row
		vc!.closer = self
		vc?.familiare = self.componentiFam[indexPath.row]
		if IS_IPAD {
			mm_drawerController.showDetailViewController(navigation, sender: nil)
		} else {
			self.navigationController?.pushViewController(vc!, animated: true)
		}
		buttonMenu.closeMenu()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.componentiFam.count
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
    func saveFamiliare(ComponentiNucleoANF componenteNucleo: FamiliareANF ) {
        //print("PRINT IMPORTANTISSIMO", componenteNucleo.relazione.desRel, componenteNucleo.desRelazione)
        componentiRepo.insertOrUpdate(byComponente: componenteNucleo)
        
        self.componentiFam = self.componentiRepo.getComponenti()
        self.navigationController?.popViewController(animated: true)
	}
	
	func close() {
		let vc = storyboard?.instantiateViewController(withIdentifier: "empty") as? EmptyViewController
		mm_drawerController.showDetailViewController(vc!, sender: nil)
		
	}
	
	func setEdit() {
		if isEdit {
			isEdit = false
		}
	}
	
	func saveFamiliare(familiare: Familiare) {/*non usata qui*/}
    

}
