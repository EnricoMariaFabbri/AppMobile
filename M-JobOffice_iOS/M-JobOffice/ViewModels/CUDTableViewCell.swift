
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
