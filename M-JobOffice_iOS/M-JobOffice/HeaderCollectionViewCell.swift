//
//  HeaderCollectionViewCell.swift
//  M-JobOffice
//
//  Created by Stage on 21/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var labelHeader: UILabel!
	
	private func getDescription(row: Int) -> String {
		switch row {
		case 0: return "Gio."
		case 1: return "Mod."
		case 2,4: return "E"
		case 3,5: return "U"
		case 6: return "Dov"
		case 7: return "Eff"
		default: return ""
			break
		}
	}
	
	func initialize(row: Int) {
		labelHeader.text = getDescription(row: row)
	}
}
