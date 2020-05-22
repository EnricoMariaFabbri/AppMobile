//
//  BaseNotification.swift
//  AppSegreteria
//
//  Created by Leonardo Canali on 10/03/17.
//  Copyright © 2017 Sama Alessandro. All rights reserved.
//

import Foundation

class BaseNotification {
	
	
	var stringType = ""
	init() {
		
	}
	
	init(withDictionary dict : Dictionary<String, Any>) {
		stringType = dict["messageClass"] as! String
	}
	
}
