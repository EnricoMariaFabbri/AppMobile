//
//  CedoliniViewController.swift
//  M-JobOffice
//
//  Created by Stage on 30/01/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CustomAnimations
import SwiftSpinner
import QuickLook

class CedoliniViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DownloadProtocol, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
	
	//Outlets
	@IBOutlet weak var btnFiltroAnno: UIButton!
	@IBOutlet weak var tableView: CustomAnimatingTable!
	
	
	//Vars
	var params : Dictionary<String, Any> = [:]
	var arrayAnniCedolini : [Int]?
	var currentAllegatoCedolino : Allegato?
	var arrayCedolini = [Cedolino]()
	var annoSelezionato : Int?
	var initialSelection = 0
    let appDelegate = AppDelegate()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getAnniCedolini()
		tableView.intialize(tableView: self.tableView)
		
		// Do any additional setup after loading the view.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func getAnniCedolini(){
		let _ = SwiftSpinner.show("Ricerca anni", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
        let _ =  WebService.sharedInstance.cedoliniSubscriptor(byAnni: "anni").subscribe(onNext: { (data) in
			
			if let dict = (data as! Dictionary<String,Any>)["anni"] as? Array<Int>{
				self.arrayAnniCedolini = Array<Int>.init(dict)
				if self.arrayAnniCedolini != nil  && dict.count > 0{
					self.initialSelection = (self.arrayAnniCedolini?.count)! - 1
					self.btnFiltroAnno.setTitle("\(self.arrayAnniCedolini![self.initialSelection])", for: .normal)
					self.getCedolini()
				}
				else{
					UtilityHelper.presentAlertMessage("Errore", message: "Problema di comunicazione con il servizio, nessun anno disponibile", viewController: self)
					
					//TODO --> Rimuovere le seguenti istruzioni utili solo a fine di debug.
					self.annoSelezionato = 2015
					self.getCedolini()
				}
			}
		}, onError: { (error) in
			ErrorManager.presentError(error: error as NSError, vc: self)
			print(error)
			SwiftSpinner.hide()
            (UIApplication.shared.delegate as! AppDelegate).logout()
		}, onCompleted: {
			print("completed")
		}) {
			print("disposed")
		}
	}
	
	func getCedolini(){
		let _ = SwiftSpinner.show("Ricerca cedolini", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		if self.annoSelezionato == nil {
			if self.arrayAnniCedolini == nil {
				return
			}
			else{
				self.annoSelezionato = arrayAnniCedolini?[(arrayAnniCedolini?.count)! - 1]
			}
		}
		params["anno"] = self.annoSelezionato!
		let _ = WebService.sharedInstance.cedoliniSubscriptor(byElenco: "elenco",params).subscribe(onNext: { (data) in
			
			if let dict = data as? Dictionary<String,Any>{
				self.arrayCedolini = [Cedolino]()
				for cedolinoDict in dict["cedolini"] as! Array<Dictionary<String,Any>>{
					let cedolino = Cedolino(fromDictionary: cedolinoDict)
					self.arrayCedolini.append(cedolino)
				}
				self.tableView.reloadData()
				self.tableView.AnimateTable()
			}
		}, onError: { (error) in
			print(error)
			ErrorManager.presentError(error: error as NSError, vc: self)
            self.appDelegate.logout()
			SwiftSpinner.hide()
		}, onCompleted: {
			print("Completed")
			SwiftSpinner.hide()
		}) {
			print("disposed")
		}
	}
	
	@IBAction func btnFilter(_ sender: UIButton) {
		
		
		if (self.arrayAnniCedolini != nil){
			let picker = ActionSheetStringPicker(title: "Scegli valore", rows: self.arrayAnniCedolini, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
				
				sender.setTitle("\(selectedValue as? Int != nil ? selectedValue as! Int : 0000)",for: .normal)
				self.annoSelezionato = selectedValue as? Int
				self.getCedolini()
			}, cancel: nil , origin: sender)
			picker?.hideCancel = true
			picker?.show()
		}
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayCedolini.count > 0 {
			return arrayCedolini.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellCedolino") as! CedolinoTableViewCell
        if arrayCedolini.count > 0{
            cell.initialize(byCedolino: arrayCedolini[indexPath.row])
        }
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("preso")
	}
	
	
	@IBAction func btnSearch(_ sender: UIButton) {
		
		performSegue(withIdentifier: "searchModal", sender: self)
		
	}
	
	func downloadPressed(params: Dictionary<String, Any>) {
		let _ = SwiftSpinner.show("Download allegato...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
        let _ = WebService.sharedInstance.cedoliniSubscriptor(byDownload: "download", params).subscribe(onNext: { (data) in
			
			let dictOfAllegato = (data as! Dictionary<String,Any>)["cedolino"] as! Array<Dictionary<String,Any>>
			let allegatoCedolino = Allegato(with: dictOfAllegato)
			FileHelper.storeFileLocally("Temp", fileName: allegatoCedolino.documentName, data: Data(base64Encoded: allegatoCedolino.contentBase64))
			self.currentAllegatoCedolino = allegatoCedolino
			
			if IS_IPAD{
				NotificationCenter.default.post(name: Notification.Name(rawValue:SHOW_PREVIEW_NOTIFICATION), object: self, userInfo: ["documentName" : self.currentAllegatoCedolino!.documentName])
			}else{
				UtilityHelper.ShowPreview(viewController: self)
			}
		}, onError: { (error) in
			print(error)
			ErrorManager.presentError(error: error as NSError, vc: self)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("Completed")
			SwiftSpinner.hide()
		}) {
			print("disposed")
		}
	}
	
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
		return 1
	}
	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
		return FileHelper.getFileLocalPathByUrl("Temp/\(currentAllegatoCedolino!.documentName)")! as QLPreviewItem
	}
}
