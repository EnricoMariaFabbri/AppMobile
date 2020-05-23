

import UIKit

private let DETTAGLIO_VC = "dettaglioDescrizione"
private let DESCR_CELL = "descriptionCell"

class DescrPosizioneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet var table: UITableView!
	
	var array: [String]?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		table.dataSource = self
		table.delegate = self
        table.rowHeight = UITableView.automaticDimension
		populateArray()
    }

	func populateArray() {
		array = [String]()
		for i in 0...20 {
			if i == 0 {
				array!.append("Nel cielo c'è 1 uccello")
			} else {
				array!.append("Nel cielo ci sono \(i + 1) uccelli")
			}
		}
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: DESCR_CELL , for: indexPath) as! DescriptionTableViewCell
		cell.initialize(string: array![indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = storyboard?.instantiateViewController(withIdentifier: DETTAGLIO_VC) as! DettaglioDescrViewController
		vc.titolo = array![indexPath.row]
		presentAnimated(vc: vc)
	}
	
	func presentAnimated(vc: DettaglioDescrViewController) {
		
		var preHeight: CGPoint?
		
		UIView.animate(withDuration: 0.1, animations: {
			self.mm_drawerController.showDetailViewController(vc, sender: nil)
		}, completion: { _ in
			UIView.animate(withDuration: 0.05, animations: {
				preHeight = vc.viewCustom.frame.origin
				//in questo momento la view è hidden
				vc.viewCustom.frame.origin.y = vc.view.frame.height / 2
				vc.lblTitle.frame.origin.y += 20
				vc.viewPosition.frame.origin.x -= 16
				vc.viewPosition.frame.size.height = vc.viewPosition.frame.height * 2
				vc.viewPosition.frame.size.width = vc.viewPosition.frame.width * 2
			}, completion: { _ in
				UIView.animate(withDuration: 0.1, animations: {
					vc.viewCustom.isHidden = false
					vc.viewCustom.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
					vc.viewCustom.layer.shadowOffset = CGSize(width: 15, height: 15)
				}, completion: { _ in
					UIView.animate(withDuration: 0.1, animations: {
						vc.viewCustom.transform = CGAffineTransform(rotationAngle: CGFloat(0))
						vc.viewCustom.layer.shadowOffset = CGSize(width: 3, height: 3)
					}, completion: { _ in
						UIView.animate(withDuration: 0.2, animations: {
							vc.viewCustom.frame.origin = preHeight!
							vc.viewPosition.frame.size.height = 32
							vc.viewPosition.frame.size.width = 32
							vc.lblTitle.frame.origin.y -= 20
							vc.viewPosition.frame.origin.x += 16
						})
					})
				})
			})
		})
	}
}
