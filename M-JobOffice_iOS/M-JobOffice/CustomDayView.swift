

import UIKit

class CustomDayView: UIView {

	
	
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = true
		self.layer.cornerRadius = 10
		self.layer.borderWidth = 2
		self.layer.borderColor = #colorLiteral(red: 0.9371148944, green: 0.9369883537, blue: 0.9587596059, alpha: 1)
    }

	func initialize(day: WorkDay) {
		
	}

}
