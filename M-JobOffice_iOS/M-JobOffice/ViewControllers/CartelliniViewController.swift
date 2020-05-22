//
//  CartelliniViewController.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 17/11/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit
import SwiftSpinner
import ActionSheetPicker_3_0
import QuickLook

class CartelliniViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DownloadProtocol, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
	
	//Outlets
	@IBOutlet weak var btnFiltroAnno: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	var params = Dictionary<String, Any>()
	var arrayCartellini = [Cartellino]()
	var annoSelezionato : Int?
	var currentAllegatoCartellino : Allegato?
	var arrayAnniCartellini : [Int]?
	var initialSelection = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func getAnniCartellini(){
		let _ = SwiftSpinner.show("Ricerca anni", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
        let _ =  WebService.sharedInstance.cedoliniSubscriptor(byAnni: "anni").subscribe(onNext: { (data) in
			
			if let dict = (data as! Dictionary<String,Any>)["anni"] as? Array<Int>{
				self.arrayAnniCartellini = Array<Int>.init(dict)
				if self.arrayAnniCartellini != nil  && dict.count > 0{
					self.initialSelection = (self.arrayAnniCartellini?.count)! - 1
					self.btnFiltroAnno.setTitle("\(self.arrayAnniCartellini![self.initialSelection])", for: .normal)
					self.getCedolini()
				}
				else{
					UtilityHelper.presentAlertMessage("Errore", message: "Problema di comunicazione con il servizio, nessun anno disponibile", viewController: self)
					
					//TODO --> Rimuovere le seguenti istruzioni utili solo a fine di debug.
//					self.annoSelezionato = 2015
//					self.getCedolini()
				}
			}
		}, onError: { (error) in
			print(error)
		}, onCompleted: {
			print("completed")
		}) {
			print("disposed")
		}
	}
	
	func getCedolini(){
		let _ = SwiftSpinner.show("Ricerca cartellini", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		if self.annoSelezionato == nil {
			if self.arrayAnniCartellini == nil {
				return
			}
			else{
				self.annoSelezionato = arrayAnniCartellini?[(arrayAnniCartellini?.count)! - 1]
			}
		}
		params["anno"] = self.annoSelezionato!
		let _ = WebService.sharedInstance.getCartellini(params).subscribe(onNext: { (data) in
			
			if let dict = data as? Dictionary<String,Any>{
				
				for cartellinoDict in dict["cartellini"] as! Array<Dictionary<String,Any>>{
					let cartellino = Cartellino(byJson: cartellinoDict)
					self.arrayCartellini.append(cartellino)
				}
				self.tableView.reloadData()
			}
		}, onError: { (error) in
			print(error)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("Completed")
			SwiftSpinner.hide()
		}) {
			print("disposed")
		}
	}
	
	@IBAction func btnFilter(_ sender: UIButton) {
		
		
		if (self.arrayAnniCartellini != nil){
			let picker = ActionSheetStringPicker(title: "Scegli valore", rows: self.arrayAnniCartellini, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
				
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
		if arrayAnniCartellini != nil{
			return arrayAnniCartellini!.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellCartellino") as! CartellinoTableViewCell
		cell.initialize(byCedolino: arrayCartellini[indexPath.row])
		cell.delegate = self
		return cell
	}
	
	func downloadPressed(params: Dictionary<String, Any>) {
		let _ = SwiftSpinner.show("Download allegato...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		let _ = WebService.sharedInstance.downloadCartellino(params).subscribe(onNext: { (data) in
			
			let dictOfAllegato = (data as! Dictionary<String,Any>)["cartellino"] as! Array<Dictionary<String,Any>>
			let allegatoCedolino = Allegato(with: dictOfAllegato)
			FileHelper.storeFileLocally("Temp", fileName: allegatoCedolino.documentName, data: Data(base64Encoded: allegatoCedolino.contentBase64))
			self.currentAllegatoCartellino = allegatoCedolino
			
			if IS_IPAD{
				NotificationCenter.default.post(name: Notification.Name(rawValue:SHOW_PREVIEW_NOTIFICATION), object: self, userInfo: ["documentName" : self.currentAllegatoCartellino!.documentName])
			}else{
				UtilityHelper.ShowPreview(viewController: self)
			}
		}, onError: { (error) in
			print(error)
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
		return FileHelper.getFileLocalPathByUrl("Temp/\(currentAllegatoCartellino!.documentName)")! as QLPreviewItem
	}





}
