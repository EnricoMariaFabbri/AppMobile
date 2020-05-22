//
//  BSDStackMenu.swift
//  M-Accerta
//
//  Created by Leonardo Canali on 26/09/17.
//  Copyright © 2017 BSD Software. All rights reserved.
//

import UIKit

class BSDStackMenu: UIButton {
	
	var btnArray = [BSDStackMenuCell]()
	var isExpanded = false
	
	func initialize(by orderedButtonCells : [BSDStackMenuCell]){
	
		self.layer.cornerRadius = 10
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 5)
		self.layer.shadowRadius = 5
		self.layer.shadowOpacity = 0.5
		
		self.imageView?.image = #imageLiteral(resourceName: "drawer")
		btnArray = orderedButtonCells
		self.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
		
		for btn in orderedButtonCells{
			btn.alpha = 0
			self.superview?.addSubview(btn)
			let widthDifference = btn.frame.size.width - self.frame.size.width
			btn.frame.origin = CGPoint(x: self.frame.origin.x - widthDifference, y: self.frame.origin.y)
		}
	}
	
    @objc func buttonPressed(sender : UIButton){
	
		//let pressedButton = sender
		//pressedButton.setImage(#imageLiteral(resourceName: "ic_close_white"), for: .normal)

		if !isExpanded{
			openMenu()
		}else{
			closeMenu()
		}
	}
	
	func closeMenu() {
		UIView.beginAnimations("Zoomin", context: nil)
		UIView.setAnimationDuration(0.25)
		
		self.imageView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
		UIView.commitAnimations()
		
		UIView.beginAnimations("Zoomout", context: nil)
		UIView.setAnimationDuration(0.25)
		
		self.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
		UIView.commitAnimations()
		
		self.setImage(#imageLiteral(resourceName: "drawer"), for: .normal)
		
		let reversedArray = btnArray.reversed()
		for btn in reversedArray{
			let widthDifference = btn.frame.size.width - self.frame.size.width
			UIView.animate(withDuration: 0.4, animations: {
				btn.frame.origin = CGPoint(x: self.frame.origin.x - widthDifference, y: self.btnArray[0].frame.origin.y)
				btn.alpha = 0
			})
		}
		
		isExpanded = false
	}

	func openMenu() {
		UIView.beginAnimations("Zoomin", context: nil)
		UIView.setAnimationDuration(0.25)
		
		self.imageView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
		UIView.commitAnimations()
		
		UIView.beginAnimations("Zoomout", context: nil)
		UIView.setAnimationDuration(0.25)
		
		self.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
		UIView.commitAnimations()
		
		self.setImage(#imageLiteral(resourceName: "ic_dismiss_stack"), for: .normal)
		
		
		
		var yOffset = self.frame.origin.y
		
		for btn in btnArray{
			
			let widthDifference = btn.frame.size.width - self.frame.size.width
			yOffset = yOffset - btn.frame.size.height
			UIView.animate(withDuration: 0.15, animations: {
				btn.frame.origin = CGPoint(x: self.frame.origin.x - widthDifference , y: yOffset - 10)
				btn.alpha = 1
				
			}, completion: { (ok) in
				UIView.animate(withDuration: 0.2, animations: {
					btn.frame.origin = CGPoint(x: self.frame.origin.x - widthDifference , y: btn.frame.origin.y + 13)
				}, completion: { (ok) in
					UIView.animate(withDuration: 0.2, animations: {
						btn.frame.origin = CGPoint(x: self.frame.origin.x - widthDifference , y: btn.frame.origin.y - 3)
					})
				})
			})
			
		}
		
		isExpanded = true
	}
	
}
