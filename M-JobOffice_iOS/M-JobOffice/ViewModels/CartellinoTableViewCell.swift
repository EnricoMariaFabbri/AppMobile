

import UIKit

class CartellinoTableViewCell: BaseTableViewCell {

	@IBOutlet weak var btnDownload: UIButton!
	@IBOutlet weak var icona: UIImageView!
	@IBOutlet weak var descrizione: UILabel!
	
	var cartellino : Cartellino?
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
	
	func initialize(byCedolino cartellino : Cartellino){
		
		self.cartellino = cartellino
		descrizione.text = self.cartellino?.descrizione!
		
	}

	@IBAction func download(_ sender: UIButton) {
		params["cartellinoId"] = self.cartellino!.id!
		delegate?.downloadPressed(params: params)
	}
	

}
