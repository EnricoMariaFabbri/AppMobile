//
//  DrawerTableViewCell.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 02/02/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit

class DrawerTableViewCell: BaseTableViewCell{

    
    @IBInspectable var code : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
