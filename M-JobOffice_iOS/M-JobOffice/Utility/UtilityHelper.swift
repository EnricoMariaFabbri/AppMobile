

import UIKit
import QuickLook
import SwiftSpinner

class UtilityHelper: NSObject {
	
	let RELPAR = "relpar"
	
	
	static func presentAlertMessage(_ title: String, message: String, viewController: UIViewController ) {
		
        var alertController = UIAlertController()
        if IS_IPAD{
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
        else{
            alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        }
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func imageFromCode(_ code: String) -> UIImage {
        var image = UIImage(named: code)
        if image == nil {
            image = UIImage(named: "icona_default_todolist")!
        }
        return image!
    }
	
	static func ShowPreview(viewController : UIViewController){
		let previewer = PreviewController()
		previewer.delegate = viewController as? QLPreviewControllerDelegate
		previewer.dataSource = viewController as? QLPreviewControllerDataSource
		viewController.present(previewer, animated: true) {
			UIApplication.shared.isStatusBarHidden = true
		}
	}
	
	static func convertToDictionary(fromString text: String) -> [String: Any]? {
		if let data = text.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			} catch {
				print(error.localizedDescription)
			}
		}
		return nil
	}
	
//	func openPreview(pkAllegatoSelected : Int,fileDic:AnyObject,pathVar: inout String, view : UIViewController){
    func openPreview(pkAllegatoSelected : Int,fileDic:AnyObject,pathVar: String, view : UIViewController, onComplete complete:@escaping(_ path: String) -> ()) {
		var path = pathVar
		let doc = Data(base64Encoded: (fileDic["contentBase64"] as! String))
		var fileSelectedExtension = ""
		let fileName = fileDic["documentName"] as? String
		if fileName != nil{
			fileSelectedExtension = URL(fileURLWithPath: fileName!).pathExtension
			if !fileSelectedExtension.isEmpty {
				FileHelper.storeFileLocally("Temp", fileName: "\(pkAllegatoSelected).\(fileSelectedExtension)", data: doc)
				path = "Temp/\(pkAllegatoSelected).\(fileSelectedExtension)"
                complete(path)
			}
			else{
				UtilityHelper.presentAlertMessage("Errore", message: "Formato allegato non valido, contattare l'assistenza", viewController: view)
			}
			let c = PreviewController()
			c.delegate = view as? QLPreviewControllerDelegate;
			c.dataSource = view as? QLPreviewControllerDataSource;
			view.present(c, animated: true) {
				UIApplication.shared.isStatusBarHidden = true
			}
		}
		else{
			UtilityHelper.presentAlertMessage("Errore", message: "Formato allegato non valido, contattare l'assistenza", viewController: view)
		}
		
	}
	static func checkPassword(input : String) -> Bool{
		let encrypted = input.md5()
		let userRepo = UtentiRepository()
		let utente = userRepo.getUtente(by: Session.sharedInstance.token!)
		if encrypted == utente.password{
			return true
		}
		return false
	}
	
//	func getCodRelazione(relaz: String) -> Int {
//		    switch relaz.uppercased() {
//	        case "MARITO" : return 2
//	        case "FIGLIO" : return 3
//	}
	
	static func getRelazioni(vc: UIViewController) {
		let _ = WebService.sharedInstance.getRelazioni().asObservable().subscribe(onNext: { (data) in
			if let dict = data as? Dictionary<String,Any> {
				let repo = RelazioneRepository()
				if let relDict = dict["relpar"] as? [Dictionary<String,Any>] {
					for rel in relDict {
						let relazione = Relazione(by: rel)
						repo.insertRel(by: relazione)
					}
				}
			}
		}
			, onError: { (error) in
				print(error)
				ErrorManager.presentError(error: error as NSError, vc: vc)
				SwiftSpinner.hide()
		}
			, onCompleted: {
				print("Completed")
		}) {
			print("Disposed")
		}
	}
    
    static func getPeriodiANF(vc: UIViewController) {
        let _ = WebService.sharedInstance.getPeriodiANF().asObservable().subscribe(onNext: { (data) in
            if let dict = data as? Dictionary<String,Any> {
                let repo = PeriodiRepository()
                if let periodiDict = dict["periodi"] as? [Dictionary<String,Any>] {
                    for per in periodiDict {
                        let periodo = PeriodoANF(by: per)
                        repo.insertPeriodoANF(by: periodo)
                    }
                }
            }
        }
            , onError: { (error) in
                print(error)
                ErrorManager.presentError(error: error as NSError, vc: vc)
                SwiftSpinner.hide()
        }
            , onCompleted: {
                print("Completed")
        }) {
            print("Disposed")
        }
    }
}



