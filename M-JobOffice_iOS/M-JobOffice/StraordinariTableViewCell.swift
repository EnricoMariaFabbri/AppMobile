
import UIKit

class StraordinariTableViewCell: UITableViewCell {

	@IBOutlet var lblStraordinario: UILabel!
	@IBOutlet var lblTot: UILabel!
	@IBOutlet var lblPagamento: UILabel!
	@IBOutlet var lblRecuper: UILabel!
	@IBOutlet var lblBO: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func initialize(straord: Straordinario) {
		lblBO.text = straord.bo!
		lblStraordinario.text = straord.descr!
		lblTot.text = String(straord.tot!)
		lblPagamento.text = String(straord.pagamento!)
		lblRecuper.text = String(straord.recuperato!)
	}

}
