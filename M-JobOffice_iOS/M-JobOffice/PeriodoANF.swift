

import Foundation

class PeriodoANF {
	private let IDGPX_DAC_NUCFAM = "idGpxDACNucfam"
	private let IDWORKFLOW_INSTANCE = "idWorkflowInstance"
	private let ID_ENTE = "idEnte"
	private let ANNO_INIZIO = "annoInizio"
	private let ANNO_FINE = "annoFine"
	private let MESE_INIZIO = "meseInizio"
	private let MESE_FINE = "meseFine"
	private let NOTE = "note"
    
    private let IDGPX_DACDET_ANAGFIS = "idGpxDACDetanagfis"
    private let IDGPX_DAC_ANAGFIS = "idGpxDACAnagfis"
	
    var idGpxDACDetanagfis: Int?
    var idGpxDACAnagfis: Int?
	var idGpxDACNucFam: Int?
	var idWorkflowInstance: Int?
	var idEnte: Int?
	var annoInizio: Int?
	var annoFine: Int?
	var meseInizio: Int?
	var meseFine: Int?
	var note: String?
	
	init(by json: Dictionary<String,Any>) {
        idGpxDACDetanagfis = json[IDGPX_DACDET_ANAGFIS] as? Int
        idGpxDACAnagfis = json[IDGPX_DAC_ANAGFIS] as? Int
		idGpxDACNucFam = json[IDGPX_DAC_NUCFAM] as? Int
		idWorkflowInstance = json[IDWORKFLOW_INSTANCE] as? Int
		idEnte = json[ID_ENTE] as? Int
		annoInizio = json[ANNO_INIZIO] as? Int
		if annoInizio == nil {
			annoInizio = 0000
		}
		
		annoFine = json[ANNO_FINE] as? Int
		if annoFine == nil {
			annoFine = 0000
		}
		meseInizio = json[MESE_INIZIO] as? Int
		if meseInizio == nil {
			meseInizio = 0000
		}
		meseFine = json[MESE_FINE] as? Int
		if meseFine == nil {
			meseFine = 0000
		}
		note = json[NOTE] as? String
	}
    
    init() {
        
    }
	
	static func setParamsForCall(id: Int) -> Dictionary<String,Any>{
		var params = Dictionary<String,Any>()
        params["idGpxDACDetanagfis"] = -1
        params["idGpxDACAnagfis"] = -1
		params["idGpxDACNucfam"] = -1
		params["annoFine"] = DateHelper.getCurrentYear() + 1
		params["idWorkflowInstance"] = -1
		params["idEnte"] = id
		params["annoInizio"] = DateHelper.getCurrentYear()
		params["meseInizio"] = 7
		params["meseFine"] = 6
		return params
	}
}
