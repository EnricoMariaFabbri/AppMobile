//
//  Relazione.swift
//  M-JobOffice
//
//  Created by Stage on 19/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import Foundation

class Relazione {
	
	private let COD_REL = "codiceRelazione"
	private let DES_REL_M = "desRelazioneM"
	private let DES_REL_F = "desRelazioneF"
    private let DES_REL = "desRelazione"
	
	var codice: Int?
	var desRelM: String? {
		didSet {
			if desRelM != nil {
				desRel = desRelM
			}
		}
	}
	var desRelF: String? {
		didSet {
			if desRelF != nil {
				desRel = desRelF
			}
		}
	}
	var desRel: String?
	
	init(by json: Dictionary<String,Any>) {
		codice = json[COD_REL] as? Int
        desRel = json[DES_REL] as? String
		desRelM = json[DES_REL_M] as? String
		desRelF = json[DES_REL_F] as? String
	}
	init() {
		
	}
	
}
