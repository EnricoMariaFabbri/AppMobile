

import Foundation

class RichiestaANF {
	private let ID_NUCLEO_FAMILIARE = "idNucleoFamiliare" //campo che non c'è su periodo_detrazione
	private let ID_ENTE = "idEnte"
	private let DATA_RICHIESTA = "dataRichiesta"
	private let ANNO_INIZIO = "annoInizio" //campo che non c'è su periodo_detrazione
	private let ANNO_FINE = "annoFine" //campo che non c'è su periodo_detrazione
	private let MESE_INIZIO = "meseInizio"
	private let MESE_FINE = "meseFine"
	private let FAMILIARI = "componentiNucleo" //campo che non c'è su periodo_detrazione
    
    /*
    //campi aggiunti da DetrazioneANF
    private let ID = "id"
    private let ANNO_FISCALE = "annoFiscale"
    private let IDGPX_DACDET_ANAGFIS = "idGpxDACDetanagfis"
    private let IDGPX_DAC_ANAGFIS = "idGpxDACAnagfis"
    private let NOTE = "note"
    private let FLG_ALIQ_FISSA = "flgAliqfissa"
    private let PRC_ALIQ_FISSA = "prcAliqFissa"
    private let IMP_REDD_ULT = "impReddult"
    private let FLG_BONUS_DL = "flgBonusDL6614"
    private let TIP_BONUS = "tipBonusDL6614"
    private let FLG_BONUS_PROD_REDDITO = "flgBonusProdReddito"
    private let FLG_FAM_NUMEROSE = "flgFamnumerose"
    private let PRC_FAM_NUMEROSE = "prcFamnumerose"
    private let STATO_RICHIESTA = "statoRichiesta"
    private let DETAIL_DOWNLOADED = "detailDownloaded"
    private let ID_WORKFLOW_INSTANCE = "idWorkflowInstance"
    */
	
	
	var id_nucleo: Int?
	var id_ente: Int?
	var data_richiesta: String?
	var anno_inizio: Int?
	var anno_fine: Int?
	var mese_inizio: Int?
	var mese_fine: Int?
	var familiari = [FamiliareANF]()
    
    /*
    //campi presi da DetrazioneANF
    var id: Int?
    var annoFiscale: Int?
    var idGpxDACDetanagfis: Int?
    var idGpxDACAnagfis: Int?
    var note: String?
    var flgAliqfissa: Bool?
    var prcAliqFissa: Double?
    var impReddult: Double?
    var flgBonusDL6614: Bool?
    var tipBonusDL6614: String?
    var flgBonusProdReddito: Bool?
    var flgFamnumerose: Bool?
    var prcFamnumerose: Double?
    var statoRichiesta: Int?
    var detailDownloaded: Bool?
    var idWorkflowInstance: Int?
    */
	
	init(by json: Dictionary<String,Any>) {
		id_nucleo = json[ID_NUCLEO_FAMILIARE] as? Int
		id_ente = json[ID_ENTE] as? Int
		data_richiesta = json[DATA_RICHIESTA] as? String
		anno_inizio = json[ANNO_INIZIO] as? Int
		anno_fine = json[ANNO_FINE] as? Int
		mese_inizio = json[MESE_INIZIO] as? Int
		mese_fine = json[MESE_FINE] as? Int
		let famiglie = json[FAMILIARI] as? [Dictionary<String,Any>]
		for famiglia in famiglie! {
			let familiare = FamiliareANF(by: famiglia)
			familiari.append(familiare)
		}
        
        //TODO fai il by json per i campi presi da DetrazioneANF
		
	}
	
	init() {
		
	}
	
	func getParams() -> Dictionary<String,Any> {
		var params = Dictionary<String,Any>()
		params[ID_NUCLEO_FAMILIARE] = id_nucleo
		params[ID_ENTE] = id_ente
		params[DATA_RICHIESTA] = data_richiesta
		params[ANNO_INIZIO] = anno_inizio
		params[ANNO_FINE] = anno_fine
		params[MESE_INIZIO] = mese_inizio
		params[MESE_FINE] = mese_fine
		var array = [Dictionary<String,Any>]()
		for famiglie in familiari {
			array.append(famiglie.getParams())
		}
		params[FAMILIARI] = array
		return params
	}
}



