

import Foundation


class DetrazioneANF {
    
    private let ID = "id"
    private let ID_ENTE = "idEnte"
    private let ANNO_FISCALE = "annoFiscale"
    private let IDGPX_DACDET_ANAGFIS = "idGpxDACDetanagfis"
    private let IDGPX_DAC_ANAGFIS = "idGpxDACAnagfis"
    private let MESE_INIZIO = "meseInizio"
    private let MESE_FINE = "meseFine"
    private let NOTE = "note"
    private let DATA_RICHIESTA = "dataRichiesta"
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
    
    var id: Int?
    var idEnte: Int?
    var annoFiscale: Int?
    var idGpxDACDetanagfis: Int?
    var idGpxDACAnagfis: Int?
    var meseInizio: Int?
    var meseFine: Int?
    var note: String?
    var dataRichiesta: String?
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
    
    init(by json: Dictionary<String,Any>) {
        /*
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
        */
    }
    
    init() {
        
    }
    
    func getParams() -> Dictionary<String,Any> {
        var params = Dictionary<String,Any>()
        params[ID] = id
        params[ID_ENTE] = idEnte
        params[ANNO_FISCALE] = annoFiscale
        params[IDGPX_DACDET_ANAGFIS] = idGpxDACDetanagfis
        params[IDGPX_DAC_ANAGFIS] = idGpxDACAnagfis
        params[MESE_INIZIO] = meseInizio
        params[MESE_FINE] = meseFine
        params[NOTE] = note
        params[DATA_RICHIESTA] = dataRichiesta
        params[FLG_ALIQ_FISSA] = flgAliqfissa
        params[PRC_ALIQ_FISSA] = prcAliqFissa
        params[IMP_REDD_ULT] = impReddult
        params[FLG_BONUS_DL] = flgBonusDL6614
        params[TIP_BONUS] = tipBonusDL6614
        params[FLG_BONUS_PROD_REDDITO] = flgBonusProdReddito
        params[FLG_FAM_NUMEROSE] = flgFamnumerose
        params[PRC_FAM_NUMEROSE] = prcFamnumerose
        params[DETAIL_DOWNLOADED] = detailDownloaded
        params[STATO_RICHIESTA] = statoRichiesta
        params[ID_WORKFLOW_INSTANCE] = idWorkflowInstance
        return params
    }
}
