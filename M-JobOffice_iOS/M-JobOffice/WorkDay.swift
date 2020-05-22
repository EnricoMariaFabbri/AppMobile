//
//  Daily.swift
//  M-JobOffice
//
//  Created by Stage on 21/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import Foundation

private let RIFCOL0 = "rifcol0"
private let RIFCOL2 = "rifcol2"
private let RIFCOL3 = "rifcol3"
private let RIFCOL4 = "rifcol4"
private let RIFCOL5 = "rifcol5"
private let RIFCOL6 = "rifcol6"
private let RIFCOL13 = "rifcol13"
private let COL0 = "col0"
private let COL1 = "col1"
private let COL2 = "col2"
private let COL3 = "col3"
private let COL4 = "col4"
private let COL5 = "col5"
private let COL6 = "col6"
private let COL7 = "col7"
private let COL8 = "col8"
private let COL9 = "col9"
private let COL10 = "col10"

class WorkDay {
	
	var number: Int?
	var descr: String?
	var mod: String?
	var morningE: String?
	var morningU: String?
	var afterE: String?
	var afterU: String?
	var oreDovute: Int?
	var oreEffettuate: Int?
	var debito: Int?
	var ecc: String?
	var str: String?
	var turno: Int?
	var giustificativi: String?
	var error: Bool?
	
	init() {
		
	}
	
	init(by json: Dictionary<String,Any>) {
		
	}
	
	
	static func getArrayFields() -> [String] {
		let array = ["Ore dovute: ","Ore effettuate: ", "Debito: ", "Ecc: ", "Str: ", "Turno: ", "Giustificativi: "]
		return array
	}
}
