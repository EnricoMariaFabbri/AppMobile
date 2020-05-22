//
//  Familiare.swift
//  M-JobOffice
//
//  Created by Stage on 09/11/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import Foundation

class Familiare {
    
	private let IDGPX_DACDET_FAM = "idGpxDACDetfamcarfisc"
	private let ID_ANAGRAFE_UNICA = "idAn1DACAnagrafeUnica"
	private let COD_RELAZIONE = "codiceRelazione"
	private let DES_RELAZIONE = "desRelazione"
	private let COGNOME = "cognome"
	private let NOME = "nome"
	private let SESSO = "sesso"
	private let DES_SESSO = "desSesso"
	private let LUOGO_NASCITA = "luogoNascita"
	private let PROV_NASCITA = "provNascita"
	private let DATA_NASCITA = "dataNascita"
	private let CFS = "cfs"
	private let FLG_CARICO = "flgCarico"
	private let FLG_INABILE = "flgInabile"
	private let FLG_STUDAPPR = "flgStudappr"
	private let PRC_CARICO = "prcCarico"
	
	var relazione = Relazione()
	var idgpx_dacdet: Int?
	var id_anagrafe: Int?
	var cognome: String?
	var nome: String?
	var sesso: Int?
	var des_sesso: String?
	var luogo_nascita: String?
	var prov_nascita: String?
	var data_nascita: String?
	var cf: String?
	var flag_carico: Bool?
	var flag_inabile: Bool?
	var flag_studappr: Bool?
	var prc_carico: Double?
	
	init(by json: Dictionary<String,Any>){
		idgpx_dacdet = json[IDGPX_DACDET_FAM] as? Int
		id_anagrafe = json[ID_ANAGRAFE_UNICA] as? Int
		sesso = json[SESSO] as? Int
		relazione.codice = json[COD_RELAZIONE] as? Int
		if (sesso) == 1 {
			relazione.desRelM = json[DES_RELAZIONE] as? String
		} else {
			relazione.desRelF = json[DES_RELAZIONE] as? String
		}
		cognome = json[COGNOME] as? String
		nome = json[NOME] as? String
		des_sesso = json[DES_SESSO] as? String
		luogo_nascita = json[LUOGO_NASCITA] as? String
		prov_nascita = json[PROV_NASCITA] as? String
		data_nascita = json[DATA_NASCITA] as? String
		cf = json[CFS] as? String
		flag_carico = json[FLG_CARICO] as? Bool
		flag_inabile = json[FLG_INABILE] as? Bool
		flag_studappr = json[FLG_STUDAPPR] as? Bool
		prc_carico = json[PRC_CARICO] as? Double
	}

	init() {
		
	}
	
	func getParams() -> Dictionary<String,Any> {
		var params = Dictionary<String,Any>()
		params[IDGPX_DACDET_FAM] = idgpx_dacdet
		params[ID_ANAGRAFE_UNICA] = id_anagrafe
		params[COD_RELAZIONE] = relazione.codice
		if sesso == 1 {
			params[DES_RELAZIONE] = relazione.desRelM
		} else {
			params[DES_RELAZIONE] = relazione.desRelF
		}
		params[COGNOME] = cognome
		params[NOME] = nome
		params[SESSO] = sesso
		params[DES_SESSO] = des_sesso
		params[LUOGO_NASCITA] = luogo_nascita
		params[PROV_NASCITA] = prov_nascita
		params[DATA_NASCITA] = data_nascita
		params[CFS] = cf
		params[FLG_CARICO] = flag_carico
		params[FLG_INABILE] = flag_inabile
		params[FLG_STUDAPPR] = flag_studappr
		params[PRC_CARICO] = prc_carico
		return params
	}
}
