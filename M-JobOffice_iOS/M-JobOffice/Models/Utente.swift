//
//  Utente.swift
//  AppSegreteria
//
//  Created by Leonardo Canali on 27/02/17.
//  Copyright © 2017 Sama Alessandro. All rights reserved.
//

import Foundation
class Utente{
    
	//chiavi
	internal let userKey = "sicrawebUsername"
	internal let enteKey = "descrizioneEnte"
	internal let listaAooKey = "listaAoo"
	internal let descrizioneUtenteKey = "descrizioneUtente"
	internal let pinEnabledKey = "PinEnabled"
	internal let pinCodeKey = "PinCode"
	internal let logoutTimerKey = "LogoutTimer"
	
	private var username : String?
	var password : String?
	
	private var ente : String?
	private var descrizione : String?
	public var listeAoo = [ListaAooUtente]()
	private var token : String?
	var pinCode : String?
	var logoutTimer : Int?
	var isSelezionato = false
	var pinEnabled = false
	var richiediPassword = false
	
	init() {
		
	}
	
	init(JSON : NSDictionary, token : String) {
		username = JSON[userKey] as? String
		ente = JSON[enteKey] as? String
		self.token = token
//		let listeAooJson = JSON[listaAooKey] as? Array<Dictionary<String,Any>>
//		if listeAoo.count > 0{
//			
//		}
//		for lista in listeAooJson{
//			
//			let l = ListaAooUtente(JSON: lista, token: self.token!)
//			listeAoo.append(l)
//		}
		descrizione = JSON[descrizioneUtenteKey] as? String
	}
	
	var sUsername : String {
		set { username = newValue }
		get { return username! }
	}
	
	var descrizioneEnte : String {
		set { ente = newValue }
		get { return ente! }
	}
	
	var descrizioneUtente : String {
		set { descrizione = newValue }
		get { return descrizione! }
	}
	
	var tokenUtente : String {
		set { self.token = newValue }
		get { return self.token! }
	}
	
	
	
	
}
