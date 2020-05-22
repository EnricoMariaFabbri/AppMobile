//
//  CheckBox.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 29/05/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

 var checked = false
	
	override func draw(_ rect: CGRect) {
		self.addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
	}
	
    @objc func touchedUpInside(){
		if checked {
			setImage(#imageLiteral(resourceName: "check-deselected"), for: .normal)
		}else{
			setImage(#imageLiteral(resourceName: "check-selected"), for: .normal)
		}
		checked = !checked
	}
	
	func getChecked() -> Bool{
		return checked
	}

}
