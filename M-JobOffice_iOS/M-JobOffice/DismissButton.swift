

import UIKit

class DismissButton: UIButton {
	
	
	@IBInspectable var isHiddenIfIsIphone : String?//Per modali
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.addTarget(self, action: #selector(ButtonMenu.toggleMenu), for: .touchUpInside)
	}
	
	override func draw(_ rect: CGRect) {
		if let status = isHiddenIfIsIphone?.uppercased(){
			if status == "TRUE" && IS_IPHONE{
				self.isHidden = true
			}
		}
	}
	
	func toggleMenu() {
		
		if IS_IPAD{
			(self.next?.next as? UIViewController)?.dismiss(animated: true, completion: nil)
		}
		
		
	}
	
}
