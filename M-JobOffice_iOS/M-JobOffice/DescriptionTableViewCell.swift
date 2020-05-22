//
//  DescriptionTableViewCell.swift
//  M-JobOffice
//
//  Created by Stage on 23/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit



class DescriptionTableViewCell: UITableViewCell {

	@IBOutlet var descrLbl: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func initialize(string: String) {
		descrLbl.text = string
	}

}
