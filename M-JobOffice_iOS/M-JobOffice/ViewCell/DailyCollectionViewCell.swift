//
//  DailyCollectionViewCell.swift
//  M-JobOffice
//
//  Created by Stage on 21/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
	
	
	@IBOutlet var numberLabel: UILabel!
	@IBOutlet var weekdayLabel: UILabel!
	@IBOutlet var modLabel: UILabel!
	@IBOutlet var morningElbl: UILabel!
	@IBOutlet var morningUlbl: UILabel!
	@IBOutlet var afterElbl: UILabel!
	@IBOutlet var afterUlbl: UILabel!
	@IBOutlet var greenDot: UIImageView!
	@IBOutlet var stack: UIStackView!
	@IBOutlet var topDistance: NSLayoutConstraint!
	
	
	func initialize(day: WorkDay) {
		contentView.backgroundColor = #colorLiteral(red: 0.9371148944, green: 0.9369883537, blue: 0.9587596059, alpha: 1)
		self.contentView.layer.masksToBounds = true
		self.contentView.layer.cornerRadius = 10
		self.contentView.layer.borderWidth = 2
		self.contentView.layer.borderColor = #colorLiteral(red: 0.9371148944, green: 0.9369883537, blue: 0.9587596059, alpha: 1)
		self.numberLabel.text = String(day.number!)
		self.weekdayLabel.text = day.descr!
		self.modLabel.text = day.mod!
		self.morningElbl.text = day.morningE!
		self.morningUlbl.text = day.morningU!
		self.afterElbl.text = day.afterE!
		self.afterUlbl.text = day.afterU!
		if day.descr == "D" {
			greenDot.image = #imageLiteral(resourceName: "redDot")
			stack.isHidden = true
			topDistance.constant = (self.contentView.frame.size.height / 2) - 30
		} else {
			greenDot.image = #imageLiteral(resourceName: "Green dot")
			stack.isHidden = false
			topDistance.constant =  3
		}
	}
	
	override var isSelected: Bool {
		didSet {
			if weekdayLabel.text != "D" {
				if isSelected {
					contentView.backgroundColor = #colorLiteral(red: 0.353084445, green: 0.6340804696, blue: 0.167444855, alpha: 1)
					greenDot.image = #imageLiteral(resourceName: "whiteDot")
				} else {
					contentView.backgroundColor = #colorLiteral(red: 0.9371148944, green: 0.9369883537, blue: 0.9587596059, alpha: 1)
					greenDot.image = #imageLiteral(resourceName: "Green dot")
					
				}
			}
		}
	}
}
