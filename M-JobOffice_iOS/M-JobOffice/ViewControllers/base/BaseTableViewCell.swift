
import UIKit

class BaseTableViewCell: UITableViewCell {

	@IBOutlet var txtNome: UILabel!
	@IBOutlet var txtParentela: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        
        //Customize selection color
        let view = UIView()
        view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        self.selectedBackgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func initialize(familiare: Familiare? = nil) {
		if familiare != nil {
			if familiare!.nome != nil {
				txtNome.text = familiare!.nome!
			}
			if familiare!.cognome != nil {
				txtNome.text?.append(" \(familiare!.cognome!)")
			}
			txtParentela.text = familiare!.relazione.desRel ?? "Nessuna"
		} else {
			txtNome.text = ""
			txtParentela.text  = ""
		}
		
	}
	
	func initializeANF(familiareANF: FamiliareANF? = nil) {
		if familiareANF != nil {
			if familiareANF!.nome != nil {
				txtNome.text = familiareANF!.nome!
			}
			if familiareANF!.cognome != nil {
				txtNome.text?.append(" \(familiareANF!.cognome!)")
			}
            txtParentela.text = familiareANF!.relazione.desRel ?? "Nessuna"
		} else {
			txtNome.text = ""
			txtParentela.text  = ""
		}
		
	}
}
