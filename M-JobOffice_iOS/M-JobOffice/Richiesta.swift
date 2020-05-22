//
//  Richiesta.swift
//  M-JobOffice
//
//  Created by Stage on 09/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import Foundation

class Richiesta {
	
	private let IDGPX_DAC_ANAGFIS = "idGpxDACAnagfis"
	private let IDGPX_DACDET_ANAGFIS = "idGpxDACDetanagfis"
	private let ID_ENTE = "idEnte"
	private let DATA_RICHIESTA = "dataRichiesta"
	private let ANNO_FISCALE = "annoFiscale"
	private let MESE_INIZIO = "meseInizio"
	private let MESE_FINE = "meseFine"
	private let FLG_ALIQ_FISSA = "flgAliqfissa"
	private let PRC_ALIQ_FISSA = "prcAliqFissa"
	private let IMP_REDD_ULT = "impReddult"
	private let FLG_BONUS_DL = "flgBonusDL6614"
	private let TIP_BONUS = "tipBonusDL6614"
	private let FLG_BONUS_PROD_REDDITO = "flgBonusProdReddito"
	private let FLG_FAM_NUMEROSE = "flgFamnumerose"
	private let PRC_FAM_NUMEROSE = "prcFamnumerose"
	private let FAMILIARI = "componentiNucleo"
	
	var id_dac_anag:Int?
	var id_dacdec_anag: Int?
	var id_ente: Int?
	var data_richiesta: String?
	var anno_fiscale: Int?
	var mese_inizio: Int?
	var mese_fine: Int?
	var flg_aliq_fissa: Bool?
	var prc_aliq_fissa: Double?
	var imp_reddult: Double?
	var flg_bonus: Bool?
	var tip_bonus: String?
	var flg_bonus_prod_reddito: Bool?
	var flg_fam_numerose: Bool?
	var prc_fam_numerose: Double?
	var familiari = [Familiare]()
	
	init(by json: Dictionary<String,Any>) {
		id_dac_anag = json[IDGPX_DAC_ANAGFIS] as? Int
		id_dacdec_anag = json[IDGPX_DACDET_ANAGFIS] as? Int
		id_ente = json[ID_ENTE] as? Int
		data_richiesta = json[DATA_RICHIESTA] as? String
		anno_fiscale = json[ANNO_FISCALE] as? Int
		mese_inizio = json[MESE_INIZIO] as? Int
		mese_fine = json[MESE_FINE] as? Int
		flg_aliq_fissa = json[FLG_ALIQ_FISSA] as? Bool
		prc_aliq_fissa = json[PRC_ALIQ_FISSA] as? Double
		imp_reddult = json[IMP_REDD_ULT] as? Double
		flg_bonus = json[FLG_BONUS_DL] as? Bool
		tip_bonus = json[TIP_BONUS] as? String
		flg_bonus_prod_reddito = json[FLG_BONUS_PROD_REDDITO] as? Bool
		flg_fam_numerose = json[FLG_FAM_NUMEROSE] as? Bool
		prc_fam_numerose = json[PRC_FAM_NUMEROSE] as? Double
		let famiglie = json[FAMILIARI] as? [Dictionary<String,Any>]
		for famiglia in famiglie! {
			let familiare = Familiare(by: famiglia)
			familiari.append(familiare)
		}
		
	}

	init() {
		
	}
	
	func getParams() -> Dictionary<String,Any> {
		var params = Dictionary<String,Any>()
		params[IDGPX_DAC_ANAGFIS] = id_dac_anag
		params[IDGPX_DACDET_ANAGFIS] = id_dacdec_anag
		params[ID_ENTE] = id_ente
		params[DATA_RICHIESTA] = data_richiesta
		params[ANNO_FISCALE] = anno_fiscale
		params[MESE_INIZIO] = mese_inizio
		params[MESE_FINE] = mese_fine
		params[FLG_ALIQ_FISSA] = flg_aliq_fissa
		params[PRC_ALIQ_FISSA] = prc_aliq_fissa
		params[IMP_REDD_ULT] = imp_reddult
		params[FLG_BONUS_DL] = flg_bonus
		params[TIP_BONUS] = tip_bonus
		params[FLG_BONUS_PROD_REDDITO] = flg_bonus_prod_reddito
		params[FLG_FAM_NUMEROSE] = flg_fam_numerose
		params[PRC_FAM_NUMEROSE] = prc_fam_numerose
		var array = [Dictionary<String,Any>]()
		for famiglie in familiari {
			array.append(famiglie.getParams())
		}
		params[FAMILIARI] = array
		return params
	}
}

