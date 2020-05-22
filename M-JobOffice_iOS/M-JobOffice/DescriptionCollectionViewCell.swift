//
//  DescriptionCollectionViewCell.swift
//  M-JobOffice
//
//  Created by Stage on 21/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var descLabel: UILabel!
	
	func initialize(day: WorkDay, count: Int) {
		switch count {
		case 1: descLabel.text = day.mod!
		case 2: descLabel.text = day.morningE!
		case 3: descLabel.text = day.morningU!
		case 4: descLabel.text = day.afterE!
		case 5: descLabel.text = day.afterU!
		case 6: descLabel.text = String(day.oreDovute!)
		case 7: descLabel.text = String(day.oreEffettuate!)
		default: descLabel.text = "Errore"
			break
		}
	}
}
