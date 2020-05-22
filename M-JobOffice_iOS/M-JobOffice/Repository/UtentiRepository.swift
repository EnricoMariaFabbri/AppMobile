//
//  UtentiRepository.swift
//  AppSegreteria
//
//  Created by Sama Alessandro on 16/01/17.
//  Copyright © 2017 Canali Leonardo. All rights reserved.
//

import UIKit


class UtentiRepository: BaseRepository {
	
	
	func insertUtente(_ utente : Utente) {
		db.beginTransaction()
		let query = "INSERT INTO Utenti (Username,Password,Token,Ente,DescrizioneUtente,Selezionato, RichiediPassword) values (:username,:password,:token,:ente,:descrizioneUtente,:selezionato,:richiediPassword)"
		
		self.db.executeUpdate(query, withParameterDictionary: ["username":Session.sharedInstance.username!,
		                                                       "password":Session.sharedInstance.password!,
		                                                       "token": utente.tokenUtente,
		                                                       "ente" : utente.descrizioneEnte,
		                                                       "descrizioneUtente": utente.descrizioneUtente,
		                                                       "selezionato" : utente.isSelezionato == false ? 0 : 1,
		                                                       "richiediPassword" : utente.richiediPassword == false ? 0 : 1,
		                                                       "pinEnabled" : utente.pinEnabled == false ? 0 : 1,
		                                                       "pinCode" : utente.pinCode != nil ? utente.pinCode! : "",
		                                                       "logoutTimer" : utente.logoutTimer != nil ? utente.logoutTimer! : 0])
		db.commit()
	}
	func getUtenti() -> [Utente]{
		var arrayUtenti = Array<Utente>()
		let query = "SELECT * FROM Utenti"
		do {
			let result = try self.db.executeQuery(query, values: nil)
			while result.next() {
				let utente = Utente()
                utente.descrizioneEnte = result.string(forColumn: "Ente") ?? ""
                utente.descrizioneUtente = result.string(forColumn: "DescrizioneUtente") ?? ""
                utente.sUsername = result.string(forColumn: "Username") ?? ""
                utente.tokenUtente = result.string(forColumn: "Token") ?? ""
				utente.richiediPassword = result.bool(forColumn: "richiediPassword")
				utente.isSelezionato = result.bool(forColumn: "Selezionato")
				arrayUtenti.append(utente)
				
			}
		} catch {
			print(error)
		}
		return arrayUtenti
		
	}
	
	func getUtente(by token : String) -> Utente{
		let utente = Utente()
		let query  = "SELECT * FROM Utenti WHERE token == '\(token)'"
		do {
			let result = try self.db.executeQuery(query, values: nil)
			while result.next() {
                utente.descrizioneEnte = result.string(forColumn: "Ente") ?? ""
				utente.descrizioneUtente = result.string(forColumn: "descrizioneUtente") ?? ""
				utente.sUsername = result.string(forColumn: "Username") ?? ""
				utente.password = result.string(forColumn: "Password")
				utente.richiediPassword = result.bool(forColumn: "RichiediPassword") == true ? true : false
				utente.tokenUtente = result.string(forColumn: "Token") ?? ""
				utente.isSelezionato = result.bool(forColumn: "Selezionato")
				utente.pinEnabled = result.bool(forColumn: "pinEnabled")
				utente.pinCode = result.string(forColumn: "pinCode")
				utente.logoutTimer = Int(result.int(forColumn: "logoutTimer"))
			}
		} catch {
			print(error)
		}
		return utente
		
		
	}
	
	func deselezionaUtente(byToken token : String){
		do{
			db.beginTransaction()
			let query = "UPDATE Utenti SET Selezionato = 0 WHERE Token == '\(token)'"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
	}
	func selezionaUtente(byToken token : String){
		do{
			db.beginTransaction()
			let query = "UPDATE Utenti SET Selezionato = 1 WHERE Token == '\(token)'"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
	}
	
	func setRichiediPassword(byToken token : String, richiediPassword : Bool){
		do{
			db.beginTransaction()
			var query = ""
			if richiediPassword{
				query = "UPDATE Utenti SET RichiediPassword = 1 WHERE Token == '\(token)'"
			}else{
				query = "UPDATE Utenti SET RichiediPassword = 0 WHERE Token == '\(token)'"
			}
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
		
	}
	
	func setPinEnabled(byToken token : String, pinEnabled : Bool, pinCode : String){
		do{
			db.beginTransaction()
			var query = ""
			if pinEnabled{
				query = "UPDATE Utenti SET PinEnabled = 1, PinCode = \(pinCode) WHERE Token == '\(token)'"
			}else{
				query = "UPDATE Utenti SET PinEnabled = 0, PinCode = \(pinCode) WHERE Token == '\(token)'"
			}
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
		
	}
	
	func setLogoutTimer(byToken token : String, logoutTimer : Int){
		do{
			db.beginTransaction()
			let query = "UPDATE Utenti SET LogoutTimer = \(logoutTimer) WHERE Token == '\(token)'"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
		
	}
	
	
	func deleteUtente(byToken token : String){
		do{
			db.beginTransaction()
			let query = "DELETE FROM Utenti WHERE Token == '\(token)'"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
	}
	
	func deleteAll(){
		do{
			db.beginTransaction()
			let query = "DELETE FROM Utenti"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
	}
	
	
}


//		func getFiltri() -> Array<FiltroViewModel> {
//			var arrayFiltri = Array<FiltroViewModel>()
//			let query = "SELECT * FROM Filtri"
//			do {
//				let result = try self.db.executeQuery(query, values: nil)
//				while result.next() {
//					let filtro = FiltroViewModel()
//					filtro.titolo = result.string(forColumn: "Titolo")
//					filtro.tipoFiltro = TipoFiltro(rawValue: Int(result.int(forColumn: "TipoFiltro")))!
//					filtro.tipoRicercaParametro = TipoRicercaParametro(rawValue: Int(result.int(forColumn: "TipoRicercaParametro")))!
//					filtro.isSelezionato = true //i filtri salvati su db sono sempre selezionati
//					filtro.nomeParametroRicerca = result.string(forColumn: "NomeParametroRicerca")
//					arrayFiltri.append(filtro)
//				}
//			} catch {
//				print(error)
//			}
//			if arrayFiltri.count == 0 {
//				arrayFiltri = creaFiltriBase()
//			}
//			return arrayFiltri
//		}





