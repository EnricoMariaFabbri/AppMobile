//
//  BackButton.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 29/05/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit

class BackButton: UIButton {

	override func draw(_ rect: CGRect) {
		if IS_IPAD{
			self.isHidden = true
			self.frame.size.width = 0
			return
		}
		self.addTarget(self, action: #selector(touchedUpInside), for: .touchUpInside)
	}
	
    @objc func touchedUpInside(){
		if let navigationController = (self.window?.rootViewController as? UINavigationController) {
			navigationController.popViewController(animated: true)
		}

	}

}
