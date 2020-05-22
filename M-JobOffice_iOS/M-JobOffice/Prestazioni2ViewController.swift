//
//  Prestazioni2ViewController.swift
//  M-JobOffice
//
//  Created by Stage on 23/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class Prestazioni2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "periodo2cell", for: indexPath) as! Periodo2TableViewCell
		return cell
	}
	
	var array: [Int]?
	

    override func viewDidLoad() {
        super.viewDidLoad()
		table.delegate = self
		table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
		array = [Int]()
		(0...5).forEach { (element) in
			array!.append(element)
		}
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "straordinari") as! StraordinariViewController
		self.mm_drawerController.showDetailViewController(vc, sender: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBOutlet var table: UITableView!
	
	

}
