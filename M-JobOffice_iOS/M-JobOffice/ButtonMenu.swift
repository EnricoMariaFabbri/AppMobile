

import UIKit
import MMDrawerController

class ButtonMenu: UIButton {
	
	@IBInspectable var isHiddenIfIsIpad : String?//Per modali
	
	override func draw(_ rect: CGRect) {
		if let status = isHiddenIfIsIpad?.uppercased(){
			if status == "TRUE" && IS_IPAD{
				self.isHidden = true
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.addTarget(self, action: #selector(ButtonMenu.toggleMenu), for: .touchUpInside)
	}
	
    @objc func toggleMenu() {
		
        if let drawerController = (self.window?.rootViewController as? UINavigationController)?.viewControllers[0] as? MMDrawerController {
			drawerController.toggle(.left, animated: true, completion: nil)
			drawerController.centerViewController.view.resignFirstResponder()
		}
        else if let drawerControllerIpad = ((self.window?.rootViewController as! UINavigationController).viewControllers[0] as! ContainerViewController).drawer{
            drawerControllerIpad.toggle(.left, animated: true, completion: nil)
			
        }
        
	}
}

