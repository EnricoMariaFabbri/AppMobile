//
//  AnnoTributo.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 30/06/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import Foundation

class AnnoTributo{
	
	//keys
	private let YEAR_KEY = "anno"
	private let ID_COM_KEY = "id_comune"
	private let DES_KEY = "des_comune"
	private let STATE_KEY = "stato"
	
	//Vars
	var year : Int?
	var idComune : Int?
	var desComune : String?
	var state : String?
	
	init(JSON : Dictionary<String, Any>) {
		year = JSON[YEAR_KEY] as? Int != nil ? JSON[YEAR_KEY] as! Int : -1
		idComune = JSON[ID_COM_KEY] as? Int != nil ? JSON[ID_COM_KEY] as! Int : -1
		desComune = JSON[DES_KEY] as? String != nil ? JSON[DES_KEY] as! String : "nessuna descrizione"
		state = JSON[STATE_KEY] as? String != nil ? JSON[STATE_KEY] as! String : "nessun stato"
	}
}
