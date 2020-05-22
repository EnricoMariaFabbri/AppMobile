//
//  CustomTapGesture.swift
//  M-JobOffice
//
//  Created by Stage on 27/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class CustomTapGesture: UITapGestureRecognizer {

	var isCollapsed = false
	var heightToHide: NSLayoutConstraint?
	
    @objc func tapped(sender: UIGestureRecognizer) {
		if !isCollapsed {
			heightToHide!.constant = 0
			isCollapsed = true
		} else {
			heightToHide!.constant = 230
			isCollapsed = false
		}
	}
	
	init(view: UIView, height: NSLayoutConstraint) {
        super.init(target: CustomTapGesture.self, action: #selector(tapped(sender:)))
		self.heightToHide = height
		self.view?.addGestureRecognizer(self)
	}
}
