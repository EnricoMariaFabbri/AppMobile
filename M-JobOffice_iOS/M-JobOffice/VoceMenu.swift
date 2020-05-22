//
//  VoceMenu.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 29/06/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import Foundation

class VoceMenu{
	//Keys
	private let CODE_KEY = "codice"
	private let APP_PREFIX_KEY = "appprefix"
	private let DESCRIPTION_KEY = "descrizione"
	private let ICON_KEY = "icona"
	
	
	//Vars
	var code = ""
	var appPrefix = ""
	var description = ""
	var icon : Int?
	var voce : VociMenu?
	
	init(fromDictionary dict : Dictionary<String,Any> ) {
		
		self.icon = (dict[ICON_KEY] as? Int) != nil ? dict[ICON_KEY] as! Int : 0
		self.code = (dict[CODE_KEY] as? String) != nil ? dict[CODE_KEY] as! String : "nil code"
		self.appPrefix = (dict[APP_PREFIX_KEY] as? String) != nil ? dict[APP_PREFIX_KEY] as! String : "nil app prefix"
		self.description = (dict[DESCRIPTION_KEY] as? String) != nil ? dict[DESCRIPTION_KEY] as! String : "nil description"
		
		for voce in VociMenu.getDynamicVoices(){
			if voce.rawValue == self.code{
				self.voce = voce
			}
		}
	}

	init() {
		
	}

}
