

import UIKit

class DettaglioDescrTableViewCell: UITableViewCell {
	@IBOutlet var dettaglioAlbl: UILabel!
	@IBOutlet var dettaglioBlbl: UILabel!
	@IBOutlet var dettaglioClbl: UILabel!
	
	
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func initialize(string: String) {
		dettaglioAlbl.text = string
		dettaglioBlbl.text = string
		dettaglioClbl.text = string
	}

}
