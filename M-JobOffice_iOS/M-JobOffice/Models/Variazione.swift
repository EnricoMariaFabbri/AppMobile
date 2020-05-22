//
//  Variazione.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 09/10/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import Foundation

class Variazione{
	
	var icon : Int?
	var abi : Int?
	var cab : Int?
	var cfsDeleg : String?
	var cinbban : String?
	var cineu : Int?
	var ciniban : String?
	var istituto : String?
	var cinit : String?
	var codsesso : Int?
	var codtippag : String?
	var cognomeDeleg : String?
	var conto : String?
	var datanascitaDeleg : String?
	var desistituto : String?
	var iddelegato : Int?
	var idrichiedente : Double?
	var luogonascitaDeleg : String?
	var nomeDeleg : String?
	var paese : String?
	var provnascitaDeleg : String?
	var sessoDeleg : Int?
	var varId : Int?
	var stato : StatoVariazione?
	var idTipoPagamento : Int?
	var hasDelegato : Bool = false

	
	enum CodingKeys: String {
		
		case icon = "icona"
		case abi = "abi"
		case cab = "cab"
		case cfsDeleg = "cfsDeleg"
		case cinbban = "cinBBAN"
		case cineu = "cineu"
		case ciniban = "cinIBAN"
		case cinit = "cinit"
		case codsesso = "codsessoDeleg"
        case idTipoPagamento = "idPagTpPag"
		case codtippag = "codtippag"
		case cognomeDeleg = "cognomeDeleg"
		case conto = "conto"
		case datanascitaDeleg = "datanascitaDeleg"
		case desistituto = "desistituto"
		case iddelegato = "iddelegato"
		case idrichiedente = "idrichiedente"
		case luogonascitaDeleg = "luogonascitaDeleg"
		case nomeDeleg = "nomeDeleg"
		case paese = "paese"
		case provnascitaDeleg = "provnascitaDeleg"
		case statorich = "statorich"
		case varId = "varId"
	}
	
	init() {/*Only for convenience*/}
	

	
	
	required init(fromJSON json: [String:Any]) throws {
		
		typealias k = CodingKeys
		icon = json[k.icon.rawValue] as? Int != nil ? json[k.icon.rawValue] as! Int : 0
		abi = json[k.abi.rawValue] as? Int
		cab = json[k.cab.rawValue] as? Int
		cfsDeleg = json[k.cfsDeleg.rawValue] as? String
		cinbban = json[k.cinbban.rawValue] as? String
		cineu = json[k.cineu.rawValue] as? Int
		ciniban = json[k.ciniban.rawValue] as? String
		cinit = json[k.cinit.rawValue] as? String
		codtippag = json[k.codtippag.rawValue] as? String
		cognomeDeleg = json[k.cognomeDeleg.rawValue] as? String
		conto = json[k.conto.rawValue] as? String
		datanascitaDeleg = json[k.datanascitaDeleg .rawValue] as? String
		desistituto = json[k.desistituto.rawValue] as? String
		iddelegato = json[k.iddelegato.rawValue] as? Int
        idTipoPagamento = json[k.idTipoPagamento.rawValue] as? Int
		idrichiedente = json[k.idrichiedente.rawValue] as? Double
		luogonascitaDeleg = json[k.luogonascitaDeleg.rawValue] as? String
		nomeDeleg = json[k.nomeDeleg .rawValue] as? String
		paese = json[k.paese .rawValue] as? String
		provnascitaDeleg = json[k.provnascitaDeleg .rawValue] as? String
		sessoDeleg = json[k.codsesso.rawValue] as? Int
		varId = json[k.varId.rawValue] as? Int
	}
	
	func  toJSON() -> Dictionary<String,Any>{
		typealias k = CodingKeys
		var json = Dictionary<String,Any>()
        json[k.varId.rawValue] = varId!
        json[k.icon.rawValue] = icon!
		json[k.abi.rawValue] = abi!
		json[k.cab.rawValue]  = cab!
        
        if cfsDeleg != nil && cfsDeleg != ""
        {
            json[k.cfsDeleg.rawValue] = cfsDeleg!
            json[k.cognomeDeleg.rawValue] = cognomeDeleg!
            json[k.iddelegato.rawValue] = iddelegato!
            json[k.nomeDeleg .rawValue] = nomeDeleg
            json[k.luogonascitaDeleg.rawValue] = luogonascitaDeleg
            json[k.datanascitaDeleg .rawValue] = datanascitaDeleg
            json[k.provnascitaDeleg.rawValue] = provnascitaDeleg
            json[k.codsesso.rawValue] = sessoDeleg
        }else{
            json[k.cfsDeleg.rawValue] = ""
            json[k.cognomeDeleg.rawValue] = ""
            json[k.iddelegato.rawValue] = ""
            json[k.nomeDeleg .rawValue] = ""
            json[k.luogonascitaDeleg.rawValue] = ""
            json[k.datanascitaDeleg .rawValue] = ""
            json[k.provnascitaDeleg.rawValue] = ""
            json[k.codsesso.rawValue] = ""
        }
		
		json[k.cinbban.rawValue] = cinbban!
        json[k.ciniban.rawValue] = ciniban!
		json[k.cineu.rawValue] = cineu!
		json[k.cinit.rawValue] = cinit!
		json[k.codtippag.rawValue] = codtippag!
		json[k.conto.rawValue] = conto!
		json[k.desistituto.rawValue] = desistituto!
		json[k.idrichiedente.rawValue] = idrichiedente!
		json[k.paese.rawValue] = paese!

		
		return json
	}
	
}
