//
//  StraordinariViewController.swift
//  M-JobOffice
//
//  Created by Stage on 23/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class StraordinariViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var array: [Straordinario]?

	@IBOutlet var table: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		table.delegate = self
		table.dataSource = self
		table.estimatedRowHeight = 130
        table.rowHeight = UITableView.automaticDimension
		populateArray()
        // Do any additional setup after loading the view.
    }
	
	func populateArray() {
		array = [Straordinario]()
		for i in 0...20 {
			let straordinario = Straordinario()
			straordinario.descr = "Manutenzione del server e cablaggio dell'impianto / Manutenzione del server e cablaggio dell'impianto"
			straordinario.tot = 70
			straordinario.pagamento = 70
			straordinario.recuperato = i
			straordinario.bo = "non so cosa scriverci"
			self.array?.append(straordinario)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "straordinariCell", for: indexPath) as! StraordinariTableViewCell
		cell.initialize(straord: array![indexPath.row])
		return cell
	}
    

	

}
