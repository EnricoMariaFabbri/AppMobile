//
//  CedolinoTableViewCell.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 14/03/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit

class CedolinoTableViewCell: BaseTableViewCell {

	@IBOutlet weak var btnDownload: UIButton!
	@IBOutlet weak var icona: UIImageView!
	@IBOutlet weak var descrizione: UILabel!
	
	var cedolino : Cedolino?
	var delegate : DownloadProtocol?
	var params = Dictionary<String, Any>()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func initialize(byCedolino cedolino : Cedolino){
		
		self.cedolino = cedolino
		descrizione.text = self.cedolino?.descrizione!
		
	}

	@IBAction func download(_ sender: UIButton) {
		params["cedolinoId"] = self.cedolino!.id!
		delegate?.downloadPressed(params: params)
	}
	

}
protocol DownloadProtocol {
	func downloadPressed(params : Dictionary<String, Any>) -> Void
}
