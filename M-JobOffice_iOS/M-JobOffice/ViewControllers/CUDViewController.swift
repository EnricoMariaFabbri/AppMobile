//
//  CUDViewController.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 03/02/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit
import CustomAnimations
import SwiftSpinner
import QuickLook

class CUDViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DownloadProtocol, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
	var arrayCu = [Cu]()
	var currentAllegatoCud : Allegato?
    var params = Dictionary<String, Any>()
    @IBOutlet weak var tableView: CustomAnimatingTable!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.intialize(tableView: self.tableView)
        getCud()
		getPagamenti()
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
	}
	
	func getPagamenti(){
		let _ = WebService.sharedInstance.getTipiPagamento().asObservable().subscribe(onNext: { (data) in
			print(data)
		}, onError: { (error) in
			print(error)
		}, onCompleted: {
			print("Completed")
		}) {
			print("Disposed")
		}
	}
	
	func getCud(){
		let _ = SwiftSpinner.show("ricerca CUD", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
        let _ = WebService.sharedInstance.cuSubscriptor(byElenco: "elenco").subscribe(onNext: { (data) in
			let arrayDict = (data as! Dictionary<String,Any>)["cu"] as! Array<Dictionary<String,Any>>
			for cuDict in arrayDict{
				let cedolino = Cu(fromDictionary: cuDict)
				self.arrayCu.append(cedolino)
			}
			self.tableView.reloadData()
			self.tableView.AnimateTable()
		}, onError: { (error) in
			print(error)
			SwiftSpinner.hide()
		}, onCompleted: { 
			print("Completed")
			SwiftSpinner.hide()
		}) { 
			print("Disposed")
		}
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	func downloadPressed(params: Dictionary<String, Any>) {
		let _ = SwiftSpinner.show("Download allegato...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
        let _ = WebService.sharedInstance.cuSubscriptor(byDownload: "download", params).subscribe(onNext: { (data) in
			
			let dictOfAllegato = (data as! Dictionary<String,Any>)["cu"] as! Array<Dictionary<String,Any>>
			let allegatoCud = Allegato(with: dictOfAllegato)
			FileHelper.storeFileLocally("Temp", fileName: allegatoCud.documentName, data: Data(base64Encoded: allegatoCud.contentBase64))
			self.currentAllegatoCud = allegatoCud
			let previewer = PreviewController()
			previewer.delegate = self
			previewer.dataSource = self
			self.present(previewer, animated: true) {
				UIApplication.shared.isStatusBarHidden = true
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
	
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCu.count
    }
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCud") as! CUDTableViewCell
		cell.initialize(from: arrayCu[indexPath.row])
		cell.delegate = self
        return cell
    }
	
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
		return 1
	}
	
	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
		return FileHelper.getFileLocalPathByUrl("Temp/\(currentAllegatoCud!.documentName)")! as QLPreviewItem
	}

}
