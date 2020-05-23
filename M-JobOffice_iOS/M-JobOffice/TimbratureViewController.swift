

import UIKit
import ActionSheetPicker_3_0
import SwiftSpinner
import QuickLook

private let DAILY_VC = "daily"
private let PRESTAZIONI_VC = "prestazioni2"
private let DESCRPOS_VC = "descrposizione"
private let FUNCTION = "function"
private let ANNI = "anni"
private let ELENCO = "elenco"
private let ANNO = "anno"
private let TIMBRATURE = "trimbrature"


class TimbratureViewController: UIViewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
	
	
	@IBOutlet var sc: UISegmentedControl!
	@IBOutlet var presenterView: UIView!
	@IBOutlet var pickerPeriodo: UIButton!
	@IBOutlet var pickerMese: UIButton!
	@IBOutlet var pickerCartellino: UIButton!
	@IBOutlet var downloadButton: UIButton!
	
	var arrayAnni: [Int]?
	var arrayCartellini: [Cartellino]?
	var allegato: Allegato?
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewDidAppear(_ animated: Bool) {
		initialize()
		//getAnni()
		
	}
	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	func initialize() {
		sc.tintColor = #colorLiteral(red: 0.353084445, green: 0.6340804696, blue: 0.167444855, alpha: 1)
		sc.selectedSegmentIndex = 0
		indexChanged(sc)
		downloadButton.isHidden = checkButton()
		
	}
	
	private func checkButton() -> Bool {
		if arrayCartellini != nil {
			if arrayCartellini!.isEmpty {
				return true
			} else {
				return false
			}
		} else {
			return true
		}
	}
	
	@IBAction func download(_ sender: UIButton) {
	}
	
	@IBAction func indexChanged(_ sender: UISegmentedControl) {
		switch sc.selectedSegmentIndex {
			
		case 0:
			
			let vc = storyboard?.instantiateViewController(withIdentifier: DAILY_VC) as! DailyCollectionViewController
			presentControllerInBounds(vc: vc)
			
		case 1:
			
			let vc = storyboard?.instantiateViewController(withIdentifier: PRESTAZIONI_VC) as! Prestazioni2ViewController
			presentControllerInBounds(vc: vc)
			
		case 2:
			
			let vc = storyboard?.instantiateViewController(withIdentifier: DESCRPOS_VC) as! DescrPosizioneViewController
			presentControllerInBounds(vc: vc)
			
		default: break
		}
		
		hideDetailViewController()
	}
	
	func presentControllerInBounds(vc: UIViewController) {
        addChild(vc)
		self.presenterView.addSubview(vc.view)
		vc.view.frame = presenterView.bounds
	}
	
	func hideDetailViewController() {
        if !children.isEmpty {
            for child in children {
				if child.mm_drawerController != nil {
					let vc = storyboard?.instantiateViewController(withIdentifier: "empty") as! EmptyViewController
					child.mm_drawerController.showDetailViewController(vc, sender: nil)
				}
			}
		}
	}
	
	func getAnni() {
		var params = Dictionary<String,Any>()
		params[FUNCTION] = ANNI
		let _ = SwiftSpinner.show("Ricerca cartellini...", centerLogo: #imageLiteral(resourceName: "ic_spinner"), animated: true)
		let _ = WebService.sharedInstance.getCartelliniUtente(params).subscribe(onNext: { (data) in
			
			if let dict = data as? Dictionary<String,Any> {
				if let dictAnni = dict[ANNI] as? [Dictionary<String,Any>] {
					print(dictAnni)
				}
			}
			SwiftSpinner.hide()
			
		}, onError: { (error) in
			ErrorManager.presentError(error: error as NSError, vc: self)
			print(error)
			SwiftSpinner.hide()
		}, onCompleted: {
			print("completed")
		}) {
			print("disposed")
		}
	}
	
	@IBAction func pickPeriodo(_ sender: UIButton) {
	}
	
	@IBAction func pickMese(_ sender: UIButton) {
		let array = DateHelper.getArrayMonths()
		let initialSelection = 0
		let picker = ActionSheetStringPicker(title: "Scegli anno", rows: array, initialSelection: initialSelection, doneBlock: { (picker:ActionSheetStringPicker?, selectedIndex:Int, selectedValue:Any) in
			sender.setTitle((selectedValue as! String), for: .normal)
		}, cancel: nil , origin: sender)
		picker?.hideCancel = false
		picker?.show()
	}
	
	@IBAction func pickCartellino(_ sender: UIButton) {
	}
	
	
	
	func storeFile(allegato: Allegato) {
		FileHelper.storeFileLocally("Temp", fileName: allegato.documentName, data: Data(base64Encoded: allegato.contentBase64))
	}
	
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
		return 1
	}
	
	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
		return FileHelper.getFileLocalPathByUrl("Temp/\(allegato!.documentName)")! as QLPreviewItem
	}
	
}
