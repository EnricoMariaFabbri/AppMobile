

import UIKit
import QuickLook

class MasterViewController: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {

	var documentName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
		if IS_IPAD{
			NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SHOW_PREVIEW_NOTIFICATION), object: nil, queue: OperationQueue.main) {(notifica:Notification) in
				let dict = (notifica as NSNotification).userInfo!
				self.documentName = ((dict["documentName"] as? String) != nil) ? dict["documentName"] as! String : ""
				UtilityHelper.ShowPreview(viewController: self)
			}

		}

        // Do any additional setup after loading the view.
    }
	
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
		return 1
	}
	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
		return FileHelper.getFileLocalPathByUrl("Temp/\(documentName!)")! as QLPreviewItem
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
