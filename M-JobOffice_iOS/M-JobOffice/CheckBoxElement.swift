//
//  CheckBoxElement.swift
//  AppSegreteria
//
//  Created by Leonardo Canali on 06/04/17.
//  Copyright © 2017 Sama Alessandro. All rights reserved.
//

import UIKit

class CheckBoxElement: UIButton {

	var checked = false
	
    override func draw(_ rect: CGRect) {
		self.addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
    }
	
    @objc func touchedUpInside(){
		if checked {
			setImage(#imageLiteral(resourceName: "login_unchecked"), for: .normal)
		}else{
			setImage(#imageLiteral(resourceName: "login_checked"), for: .normal)
		}
		checked = !checked
	}
	
	func getChecked() -> Bool{
		return checked
	}
	

}
