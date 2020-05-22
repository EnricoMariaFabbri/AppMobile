//
//  AddDetrazioneViewController.swift
//  M-JobOffice
//
//  Created by Stage on 09/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftSpinner

//class AddDetrazioneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FamiliareDelegate {
//	
//
//	private let YEAR_COUNT = 50
//	var arrayYear: [Int]?
//	var initialSelection = 0
//	var arrayFamiliari = [Familiare]()
//	var numFamiliari = 0
//	var meseInizio = Int()
//	var richiesta = Richiesta()
//	var richiestaDelegate: RichiestaDelegate?
//	var selectedMembro: IndexPath?
//	@IBOutlet var pickerAnni: UIButton!
//	@IBOutlet var tableView: UITableView!
//	@IBOutlet var txtEnte: UITextField!
//	@IBOutlet var checkAliquota: CheckBox!
//	@IBOutlet var txtPerAliquota: UITextField!
//	@IBOutlet var checkBonus: CheckBox!
//	@IBOutlet var txtBonus: UITextField!
//	@IBOutlet var checkDetrazProdReddito: CheckBox!
//	@IBOutlet var checkDetrazFamNum: CheckBox!
//	@IBOutlet var txtFamNum: UITextField!
//	@IBOutlet var pickerMeseInizio: UIButton!
//	@IBOutlet var pickerMeseFine: UIButton!
//	@IBOutlet var txtTipBonus: UITextField!
//	var familiareDelegate: FamiliareDelegate?
//	
//	@IBAction func pickYear(_ sender: UIButton) {
//		if (!self.arrayYear!.isEmpty){
//			let picker = ActionSheetStringPicker(title: "Scegli anno", rows: self.arrayYear , initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
//				
//				sender.setTitle("\(String(describing: selectedValue as? Int != nil ? (selectedValue as! Int) : 0000))",for: .normal)
//				
//				
//			}, cancel: nil , origin: sender)
//			picker?.hideCancel = false
//			picker?.show()
//		}
//	}
//	
//	@IBAction func pickInitMonth(_ sender: UIButton) {
//		let array = ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"]
//		let initialSelection = 0
//		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
//			self.meseInizio = selectedIndex
//			sender.setTitle(selectedValue as! String, for: .normal)
//			if let index = array.index(of: self.pickerMeseFine.title(for: .normal)!) {
//				if index < self.meseInizio {
//					self.pickerMeseFine.setTitle(array[self.meseInizio], for: .normal)
//				}
//			} else {
//				self.pickerMeseFine.setTitle(array[self.meseInizio], for: .normal)
//			}
//			self.pickerMeseFine.isUserInteractionEnabled = true
//			self.pickerMeseFine.isEnabled = true
//			
//		}, cancel: nil , origin: sender)
//		picker?.hideCancel = false
//		picker?.show()
//	}
//	
//	@IBAction func pickFinalMonth(_ sender: UIButton) {
//		let array = ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"]
//		let initialSelection = 0
//		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
//			for i in 0...array.count-1 {
//				if array[i] == selectedValue as! String {
//					if i < self.meseInizio {
//						sender.setTitle(array[self.meseInizio], for: .normal)
//					} else {
//						sender.setTitle(selectedValue as! String, for: .normal)
//					}
//				}
//			}
//		}, cancel: nil , origin: sender)
//		picker?.hideCancel = false
//		picker?.show()
//	}
//	
//	func generateYear() -> [Int] {
//		let currentYear = DateHelper.getCurrentYear()
//		let startYear = currentYear - YEAR_COUNT
//		var array = [Int]()
//		for i in startYear...currentYear {
//			array.append(i)
//		}
//		return array
//	}
//	override func viewDidLoad() {
//        super.viewDidLoad()
//		arrayYear = generateYear().reversed()
//		tableView.delegate = self
//		tableView.dataSource = self
//        // Do any additional setup after loading the view.
//		self.tableView.tableFooterView = UIView(frame: CGRect.zero)
//		self.tableView.tableFooterView?.isHidden = true
//	}
//	override func viewDidAppear(_ animated: Bool) {
//		self.pickerMeseFine.isUserInteractionEnabled = false
//		self.pickerMeseFine.isEnabled = false
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = indexPath.row == numFamiliari ? tableView.dequeueReusableCell(withIdentifier: "cellAggiungiMembro") : tableView.dequeueReusableCell(withIdentifier: "cellFamiliare") as? BaseTableViewCell
//		return cell!
//	}
//	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		if indexPath.row == numFamiliari {
//			let index = IndexPath(row: numFamiliari, section: 0)
//			numFamiliari += 1
//			tableView.beginUpdates()
//			tableView.insertRows(at: [index], with: .left)
//			tableView.endUpdates()
//			return
//		} else {
//			let vc = storyboard?.instantiateViewController(withIdentifier: "ComponenteNucleoViewController") as? ComponenteNucleoViewController
//			let navigation = UINavigationController(rootViewController: vc!)
//			navigation.modalPresentationStyle = .formSheet
//			navigation.isNavigationBarHidden = true
//			
//			vc!.delegateFamiglia = self
//			selectedMembro = indexPath
//			present(navigation, animated: true , completion: nil)
//		}
//		
//	}
//	
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return numFamiliari + 1
//	}
//	
//	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//		
//		if (editingStyle == UITableViewCellEditingStyle.delete) {
//			numFamiliari -= 1
//			tableView.beginUpdates()
//			tableView.deleteRows(at: [indexPath], with: .left)
//			tableView.endUpdates()
//		}
//	}
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//	@IBAction func dismiss(_ sender: UIButton) {
//		self.dismiss(animated: true, completion: nil)
//	}
//	
//	@IBAction func salvaDetrazione(_ sender: UIButton) {
//		if (Int(pickerAnni.title(for: .normal)!)) != nil && !txtEnte.isEmpty()  && pickerMeseInizio.title(for: .normal)! != "Mese inizio" && pickerMeseFine.title(for: .normal)! != "Mese fine" {
//			
//			richiesta.anno_fiscale = Int(pickerAnni.title(for: .normal)!)
//			richiesta.data_richiesta = String(describing: Date())
//			richiesta.flg_aliq_fissa = checkAliquota.checked
//			richiesta.flg_bonus = checkBonus.checked
//			richiesta.flg_bonus_prod_reddito = checkDetrazProdReddito.checked
//			richiesta.flg_fam_numerose = checkDetrazFamNum.checked
//			richiesta.imp_reddult = Double(txtBonus!.text!)
//			
//			richiesta.tip_bonus = txtTipBonus.text
//			richiesta.prc_aliq_fissa = Double(txtPerAliquota!.text!)
//			richiesta.prc_fam_numerose = Double(txtFamNum!.text!)
//			
//			richiestaDelegate?.setRichiesta(nuova: richiesta)
//		} else {
//			pickerAnni.shake()
//			txtEnte.shake()
//			pickerMeseFine.shake()
//			pickerMeseFine.shake()
//		}
//	}
//	
//	
//	
//	func saveFamiliare(familiare: Familiare) {
//		self.richiesta.familiari.append(familiare)
//		let cell = self.tableView.cellForRow(at: selectedMembro!) as? BaseTableViewCell
//		cell?.initialize(familiare: familiare)
//	}
//	
//}
//
//protocol RichiestaDelegate {
//	func setRichiesta(nuova: Richiesta)
//}

