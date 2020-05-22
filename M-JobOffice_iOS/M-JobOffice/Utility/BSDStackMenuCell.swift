//
//  BSDStackMenuCell.swift
//  M-Accerta
//
//  Created by Leonardo Canali on 26/09/17.
//  Copyright © 2017 BSD Software. All rights reserved.
//

import UIKit

class BSDStackMenuCell: UIView {

	@IBOutlet weak var icon: UIButton!
//	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var bgViewWidth: NSLayoutConstraint!

	
	var completition : () -> Void = {}
	var title : String?
	
	
	static func getNib(by viewController : UIViewController, on image : UIImage, title : String, backgroundColor : UIColor, action : @escaping () -> Void ) -> BSDStackMenuCell{
		let nib = UINib(nibName: "BSDStackMenuCell2", bundle: nil).instantiate(withOwner: viewController, options: nil)[0] as! BSDStackMenuCell
		nib.initialize(on: image, title: title, backgroundColor: backgroundColor, action: action)
		return nib
	}
	
	func initialize(on image : UIImage, title : String, backgroundColor : UIColor, action : @escaping () -> Void){
		
		completition = action
		self.title = title
		icon.setTitle(title, for: .normal)
//		lblTitle.text = title
		
		//lblTitle.backgroundColor = UIColor(red:0.34, green:0.59, blue:0.71, alpha: 1.00)
//		lblTitle.layer.cornerRadius = 4
//		lblTitle.layer.masksToBounds = true
//		lblTitle.layer.shadowColor = UIColor.black.cgColor
//		lblTitle.layer.shadowOffset = CGSize(width: 0, height: 5)
//		lblTitle.layer.shadowRadius = 5
//		lblTitle.layer.shadowOpacity = 0.5
		
//		icon.layer.cornerRadius = 8
		
		icon.semanticContentAttribute = UIApplication.shared
			.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        icon.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8);
		icon.setImage(image, for: .normal)
		//icon.backgroundColor = backgroundColor
		icon.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
//		icon.layer.shadowColor = UIColor.black.cgColor
//		icon.layer.shadowOffset = CGSize(width: 0, height: 5)
//		icon.layer.shadowRadius = 5
//		icon.layer.shadowOpacity = 0.5
		
		let width = title.width(withConstraintedHeight: 15, font: UIFont(name: "Helvetica Neue", size: 17)!)
		//test con 160 al posto di 195 e 220 al posto di 245
		bgViewWidth.constant = (width < 195 ? width : 245) + 50
		backgroundView.layer.cornerRadius = 15
		backgroundView.backgroundColor = backgroundColor

	}
	
    @objc func buttonPressed(sender : UIButton){
		completition()
	}
	

}

extension String {
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		
		return ceil(boundingBox.height)
	}
	
	func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		
		return ceil(boundingBox.width)
	}
}
