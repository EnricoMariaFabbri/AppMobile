

import Foundation

class FamiliareANF {
	private let ID_COMP_NUCLEO = "idComponenteNucleo"
	private let ID_ANAGRAFE_UNICA = "idAnagrafeUnica"
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
	private let FLG_ORFANO = "flgOrfano"
	private let FLG_INABILE = "flgInabile"
	private let FLG_STUDAPPR = "flgStudappr"
	private let FLG_FAMILIARE = "flgFamiliare"
	private let IMP_REDD_DIPEND = "impRedditoDipendente"
	private let IMP_REDD_ALTRO = "impRedditoAltro"
	
	var idCompNucleo: Int?
	var id_anagrafe: Int?
	var relazione = Relazione()
	var cod_relazione: Int?
	var desRelazione: String?
	var cognome: String?
	var nome: String?
	var sesso: Int?
	var des_sesso: String?
	var luogo_nascita: String?
	var prov_nascita: String?
	var data_nascita: String?
	var cf: String?
	var flag_orfano: Bool?
	var flag_inabile: Bool?
	var flag_studappr: Bool?
	var flag_familiare: Bool?
	var reddito_dipendente: Double?
	var reddito_altro: Double?
	
	init(by json: Dictionary<String,Any>){
		idCompNucleo = json[ID_COMP_NUCLEO] as? Int
		id_anagrafe = json[ID_ANAGRAFE_UNICA] as? Int
		relazione.codice = json[COD_RELAZIONE] as? Int
		sesso = json[SESSO] as? Int
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
		flag_orfano = json[FLG_ORFANO] as? Bool
		flag_inabile = json[FLG_INABILE] as? Bool
		flag_studappr = json[FLG_STUDAPPR] as? Bool
		flag_familiare = json[FLG_FAMILIARE] as? Bool
		reddito_dipendente = json[IMP_REDD_DIPEND] as? Double
		reddito_altro = json[IMP_REDD_ALTRO] as? Double
	}
	
	init() {
		
	}
	
	func getParams() -> Dictionary<String,Any> {
		var params = Dictionary<String,Any>()
		params[ID_COMP_NUCLEO] = idCompNucleo
		params[ID_ANAGRAFE_UNICA] = id_anagrafe
		params[COD_RELAZIONE] = relazione.codice!
		params[DES_RELAZIONE] = relazione.desRel
		params[COGNOME] = cognome
		params[NOME] = nome
		params[SESSO] = sesso
		params[DES_SESSO] = des_sesso
		params[LUOGO_NASCITA] = luogo_nascita
		params[PROV_NASCITA] = prov_nascita
		params[DATA_NASCITA] = data_nascita
		params[CFS] = cf
		params[FLG_ORFANO] = flag_orfano
		params[FLG_INABILE] = flag_inabile
		params[FLG_STUDAPPR] = flag_studappr
		params[FLG_FAMILIARE] = flag_familiare
		params[IMP_REDD_DIPEND] = reddito_dipendente
		params[IMP_REDD_ALTRO] = reddito_altro
		return params
	}
}
