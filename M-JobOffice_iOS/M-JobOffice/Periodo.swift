

import Foundation

class Periodo {
	
	private let IDGPX_DACDET_ANAGFIS = "idGpxDACDetanagfis"
	private let IDGPX_DAC_ANAGFIS = "idGpxDACAnagfis"
	private let IDWORKFLOW_INSTANCE = "idWorkflowInstance"
	private let ID_ENTE = "idEnte"
	private let ANNO_FISCALE = "annoFiscale"
	private let MESE_INIZIO = "meseInizio"
	private let MESE_FINE = "meseFine"
	private let NOTE = "note"
	private let STATO = "stato"
	

	
	var idGpxDACDetanagfis: Int?
	var idGpxDACAnagfis: Int?
	var idWorkflowInstance: Int?
	var idEnte: Int?
	var annoFiscale: Int?
	var meseInizio: Int?
	var meseFine: Int?
	var note: String?
	var stato: Int?
	
	
	init(by json: Dictionary<String,Any>) {
		idGpxDACDetanagfis = json[IDGPX_DACDET_ANAGFIS] as? Int
		idGpxDACAnagfis = json[IDGPX_DAC_ANAGFIS] as? Int
		idWorkflowInstance = json[IDWORKFLOW_INSTANCE] as? Int
		idEnte = json[ID_ENTE] as? Int
		annoFiscale = json[ANNO_FISCALE] as? Int
		meseInizio = json[MESE_INIZIO] as? Int
		meseFine = json[MESE_FINE] as? Int
		note = json[NOTE] as? String
		stato = json[STATO] as? Int
	}

	static func setParamsForCall(id: Int) -> Dictionary<String,Any>{
		var params = Dictionary<String,Any>()
		params["idGpxDACDetanagfis"] = -1
		params["idGpxDACAnagfis"] = -1
		params["idWorkflowInstance"] = -1
		params["idEnte"] = id
		params["annoFiscale"] = DateHelper.getCurrentYear()
		params["meseInizio"] = 1
		params["meseFine"] = 12
		return params
	}
}
