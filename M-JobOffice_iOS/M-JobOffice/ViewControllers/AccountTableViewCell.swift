
import UIKit

class AccountTableViewCell: UITableViewCell {

	@IBOutlet weak var lblUsername: UILabel!
	@IBOutlet weak var lblComune: UILabel!
	@IBOutlet weak var btnElimina: UIButton!
	@IBOutlet weak var imgCheck: UIImageView!
	var utente : Utente?
	

	func initWithUtente(utente: Utente) {
		self.utente = utente
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red:1.00, green:0.80, blue:0.50, alpha:1.00)
        selectedBackgroundView = selectedView
        lblUsername.text = self.utente?.sUsername != nil ? self.utente!.sUsername : "Nessun comune"
		lblComune.text = self.utente?.descrizioneEnte != nil ? self.utente!.descrizioneEnte : "Nessun comune"
		if (self.utente?.isSelezionato)! {
			self.imgCheck.image = UIImage(named: "icona_check_enabled")
		} else {
			self.imgCheck.image = UIImage(named: "icona_check_disabled")
		}
	}

	
	
}
