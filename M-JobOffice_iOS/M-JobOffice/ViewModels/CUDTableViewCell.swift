//
//  CUDTableViewCell.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 29/06/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import UIKit

class CUDTableViewCell: BaseTableViewCell {

	@IBOutlet weak var lblAnno: UILabel!
	
	var delegate : DownloadProtocol?
	var params = Dictionary<String, Any>()
	var CUD : Cu?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	func initialize(from CUD : Cu){
		self.CUD = CUD
		lblAnno.text = "\(CUD.anno!)"
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	@IBAction func download(_ sender: UIButton) {
		params["cuId"] = CUD!.id!
		params["prov"] = CUD!.prov!
		delegate?.downloadPressed(params: params)
	}
}
