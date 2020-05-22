//
//  FamilyHelper.swift
//  M-JobOffice
//
//  Created by Stage on 15/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import UIKit

class FamilyHelper: NSObject {

	static func getNumBy(parentela: String) -> Int{
		switch parentela.uppercased() {
		case "INTESTATARIO" : return 1
		case "CONIUGE", "MARITO", "MOGLIE": return 2
		case "FIGLIO": return 3
		default: break
		}
		return -1
	}
	
	static func getArrayParenthood() -> [String]{
		return ["INTESTATARIO","CONIUGE", "FIGLIO"]
	}
	
}
