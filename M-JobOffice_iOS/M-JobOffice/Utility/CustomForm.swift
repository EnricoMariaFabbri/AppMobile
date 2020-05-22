//
//  CustomForm.swift
//  M-JobOffice
//
//  Created by Stage on 30/01/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit

class CustomForm: UITextField {

	@IBInspectable var inset: CGFloat = 0
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: inset, dy: inset)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return textRect(forBounds: bounds)
	}
}
