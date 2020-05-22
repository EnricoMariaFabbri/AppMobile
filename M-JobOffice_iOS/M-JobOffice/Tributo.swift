//
//  Tributo.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 30/06/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import Foundation

class Tributo {
	
	//keys
	private let ID_KEY = "id_tributo"
	private let DESCRIPTION_KEY = "des_tributo"
	private let STATE_KEY = "stato"
	private let YEARS_KEY = "anni"
	
	//Vars
	var id : Int?
	var description : String?
	var state : String?
	var anni = [AnnoTributo]()
	
	init(JSON : Dictionary<String, Any>) {
		id = JSON[ID_KEY] as? Int != nil ? JSON[ID_KEY] as! Int : -1
		description = JSON[DESCRIPTION_KEY] as? String != nil ? JSON[DESCRIPTION_KEY] as! String : "nessuna descrizione"
		state = JSON[STATE_KEY] as? String != nil ? JSON[STATE_KEY] as! String : "nessuno stato"
		if let dictAnni = JSON[YEARS_KEY] as? [Dictionary<String,Any>] {
			
			for dictAnno in dictAnni{
				let anno = AnnoTributo(JSON: dictAnno)
				anni.append(anno)
			}
		}
	}
	
	
}
