//
//  Cartellino.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 17/11/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import Foundation

class Cartellino {
	
	//KEYS
	private let KEY_ID = "cartellinoId"
	private let KEY_DESCRIZIONE = "descrizione"
	private let KEY_ICONA = "icona"
	
	//VARS
	var id : Int?
	var descrizione : String?
	var icona : Int?
	
	init(byJson json : [String : Any]) {
		id = json[KEY_ID] as? Int
		descrizione = json[KEY_DESCRIZIONE] as? String != nil ? json[KEY_DESCRIZIONE] as! String : "nessuna descrizione"
		icona = json[KEY_ICONA] as? Int != nil ? json[KEY_ICONA] as! Int : -1
	}
	init() {
		
	}
	
}
