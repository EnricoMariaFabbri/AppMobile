

import UIKit

private let PERIODO_CELL = "periodoCell"

class PrestazioniViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
	
	
	@IBOutlet var table: UITableView!
	@IBOutlet var tabBar: UITabBar!
	@IBOutlet var titleLbl: UILabel!
	
	var array: [Int]? //??
	
    override func viewDidLoad() {
        super.viewDidLoad()
		table.delegate = self
		table.dataSource = self
		tabBar.delegate = self
		array = [Int]()
		(0...5).forEach { (element) in
			array!.append(element)
		}
        table.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	override func viewDidAppear(_ animated: Bool) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "straordinari") as! StraordinariViewController
		self.mm_drawerController.showDetailViewController(vc, sender: nil)
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PERIODO_CELL, for: indexPath) as! PeriodoTableViewCell
		return cell
	}
	
	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		switch item.tag {
		case 1: titleLbl.text = "Periodo precedente"
		case 2: titleLbl.text = "Periodo attuale"
		default: break
		}
		table.reloadData()
	}

}
