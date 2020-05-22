//
//  FieldTableViewCell.swift
//  M-JobOffice
//
//  Created by Stage on 22/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

	@IBOutlet var fieldLabel: UILabel!
	@IBOutlet var resultLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func initialize(descr: String, row: Int, day: WorkDay) {
		fieldLabel.text = descr
		switch row {
		case 0:
			resultLabel.text = String(day.oreDovute!)
		case 1:
			resultLabel.text = String(day.oreEffettuate!)
		case 2:
			resultLabel.text = String(day.debito!)
		case 3:
			resultLabel.text = day.ecc!
		case 4:
			resultLabel.text = day.str!
		case 5:
			resultLabel.text = String(day.turno!)
		case 6:
			resultLabel.text = day.giustificativi!
		default: break
		}
	}
}
