//
//  DettaglioDescrViewController.swift
//  M-JobOffice
//
//  Created by Stage on 23/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit


private let DETTAGLIO_CELL = "dettaglioDescrCell"

class DettaglioDescrViewController: UIViewController {
	
	@IBOutlet var viewPosition: UIImageView!
	@IBOutlet var viewCustom: UIView!
	@IBOutlet var lblTitle: UILabel!
	@IBOutlet var lblA: UILabel!
	@IBOutlet var lblB: UILabel!
	@IBOutlet var lblC: UILabel!
	
	var titolo: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	func initialize() {
		lblTitle.text = titolo!
		lblA.text = "Stringa text A"
		lblB.text = "Stringa text B"
		lblC.text = "Stringa text C"
		viewCustom.layer.borderWidth = 3
		viewCustom.layer.borderColor = #colorLiteral(red: 0.8116898647, green: 0.8135191197, blue: 0.8414333051, alpha: 1)
		viewCustom.layer.masksToBounds = true
		viewCustom.layer.cornerRadius = 10
		viewCustom.layer.shadowColor = #colorLiteral(red: 0.8116898647, green: 0.8135191197, blue: 0.8414333051, alpha: 1)
		viewCustom.layer.shadowOffset = CGSize(width: 3, height: 3)
		viewCustom.layer.shadowOpacity = 0.7
		viewCustom.layer.shadowRadius = 4.0
		viewCustom.isHidden = true //per l'animazione
	}
	
	override func viewDidAppear(_ animated: Bool) {
		initialize()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	

}
