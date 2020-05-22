//
//  CreditsViewController.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 16/10/18.
//  Copyright © 2018 Stage. All rights reserved.
//

import Foundation

class VariazioneRepository : BaseRepository {
	
	
	
	func insertVariazione(byVariazione variazione : Variazione){
		
		db.beginTransaction()
		
		let query = "INSERT INTO Variazioni (id,icon,cinBBAN,cinlBAN,cinit,paese,idTipoPagamento,codiceTipoPagamento,istituto, conto, abi, cab, cineu, idRichiedente, codSessoDelegato, nomeDelegato, cognomeDelegato, dataNascitaDelegato, provinciaNascitaDelegato, idDelegato, luogoNascitaDelegato, codFiscDelegato, stato ) values (:id,:icon,:cinBBAN,:cinlBAN,:cinit,:paese,:idTipoPagamento,:codiceTipoPagamento,:istituto,:conto,:abi,:cab,:cineu,:idRichiedente,:codSessoDelegato,:nomeDelegato,:cognomeDelegato,:dataNascitaDelegato,:provinciaNascitaDelegato,:idDelegato,:luogoNascitaDelegato,:codFiscDelegato,:stato)"

		let dict : [String:Any] = ["id":variazione.varId ?? NSNull(),
					"icon":variazione.icon ?? NSNull(),
					"cinBBAN": variazione.cinbban ?? NSNull(),
                    "cinlBAN": variazione.ciniban ?? NSNull(),
					"cinit" : variazione.cinit ?? NSNull(),
					"paese" : variazione.paese!,
					"idTipoPagamento": variazione.idTipoPagamento ?? NSNull(),
					"codiceTipoPagamento" : variazione.codtippag ?? NSNull(),
					"istituto" : variazione.desistituto ?? NSNull(),
					"conto" : variazione.conto ?? NSNull(),
					"abi" : variazione.abi ?? NSNull(),
					"cab" : variazione.cab ?? NSNull(),
					"cineu" : variazione.cineu ?? NSNull(),
					"idRichiedente" : variazione.idrichiedente ?? NSNull(),
					"codSessoDelegato" : variazione.sessoDeleg ?? NSNull(),
					"nomeDelegato" : variazione.nomeDeleg ?? NSNull(),
					"cognomeDelegato" : variazione.cognomeDeleg ?? NSNull(),
					"dataNascitaDelegato" : variazione.datanascitaDeleg ?? NSNull(),
					"provinciaNascitaDelegato" : variazione.provnascitaDeleg ?? NSNull(),
					"idDelegato" : variazione.iddelegato ?? NSNull(),
					"luogoNascitaDelegato" : variazione.luogonascitaDeleg ?? NSNull(),
					"codFiscDelegato" : variazione.cfsDeleg ?? NSNull(),
					"stato" : variazione.stato != nil ? variazione.stato!.rawValue : NSNull()]

		self.db.executeUpdate(query, withParameterDictionary: dict)
		db.commit()
		
	}
	
	func getVariazioni() -> [Variazione]{
		var variazioni = [Variazione]()
		let query  = "SELECT * FROM Variazioni"
		do {
			let result = try self.db.executeQuery(query, values: nil)
			while result.next() {
				let variazione = Variazione()
				variazione.varId = Int(result.int(forColumn: "id"))
				variazione.icon = Int(result.int(forColumn: "icon"))
				variazione.cinbban = result.string(forColumn: "cinBBAN")
                variazione.ciniban = result.string(forColumn: "cinlBAN")
				variazione.cinit = result.string(forColumn: "cinit")
				variazione.paese = result.string(forColumn: "paese")
				variazione.idTipoPagamento = Int(result.int(forColumn: "idTipoPagamento"))
				variazione.codtippag = result.string(forColumn: "codiceTipoPagamento")
				variazione.desistituto = result.string(forColumn: "istituto")
				variazione.conto = result.string(forColumn: "conto")
				variazione.abi = Int(result.int(forColumn: "abi"))
				variazione.cab = Int(result.int(forColumn: "cab"))
				variazione.cineu = Int(result.int(forColumn: "cineu"))
				variazione.idrichiedente = result.double(forColumn: "idRichiedente")
				variazione.sessoDeleg = Int(result.int(forColumn: "codSessoDelegato")) 
				variazione.nomeDeleg = result.string(forColumn: "nomeDelegato")
				variazione.cognomeDeleg = result.string(forColumn: "cognomeDelegato")
				variazione.datanascitaDeleg = result.string(forColumn: "dataNascitaDelegato")
				variazione.provnascitaDeleg = result.string(forColumn: "provinciaNascitaDelegato")
				variazione.iddelegato = Int(result.int(forColumn: "idDelegato"))
				variazione.luogonascitaDeleg = result.string(forColumn: "luogoNascitaDelegato")
				variazione.cfsDeleg = result.string(forColumn: "codFiscDelegato")
				variazione.stato = StatoVariazione(rawValue: result.string(forColumn: "stato") ?? "")
				variazioni.append(variazione)
			}
		} catch {
			print(error)
		}
		return variazioni
	}
	
	func getVariazione(byID id : Int) -> Variazione?{
		var variazione : Variazione?
		let query  = "SELECT * FROM Variazioni WHERE id = \(id)"
		do {
			let result = try self.db.executeQuery(query, values: nil)
			while result.next() {
				variazione = Variazione()
				variazione?.varId = Int(result.int(forColumn: "id"))
				variazione?.icon = Int(result.int(forColumn: "icon"))
				variazione?.cinbban = result.string(forColumn: "cinBBAN")
                variazione?.ciniban = result.string(forColumn: "cinlBAN")
				variazione?.cinit = result.string(forColumn: "cinit")
				variazione?.paese = result.string(forColumn: "paese")
				variazione?.idTipoPagamento = Int(result.int(forColumn: "idTipoPagamento"))
				variazione?.codtippag = result.string(forColumn: "codiceTipoPagamento")
				variazione?.desistituto = result.string(forColumn: "istituto")
				variazione?.conto = result.string(forColumn: "conto")
                variazione?.abi = Int(result.int(forColumn: "abi"))
                variazione?.cab = Int(result.int(forColumn: "cab"))
                variazione?.cineu = Int(result.int(forColumn: "cineu"))
				variazione?.idrichiedente = result.double(forColumn: "idRichiedente")
				variazione?.sessoDeleg = Int(result.int(forColumn: "codSessoDelegato"))
				variazione?.nomeDeleg = result.string(forColumn: "nomeDelegato")
				variazione?.cognomeDeleg = result.string(forColumn: "cognomeDelegato")
				variazione?.datanascitaDeleg = result.string(forColumn: "dataNascitaDelegato")
				variazione?.provnascitaDeleg = result.string(forColumn: "provinciaNascitaDelegato")
				variazione?.iddelegato = Int(result.int(forColumn: "idDelegato"))
				variazione?.luogonascitaDeleg = result.string(forColumn: "luogoNascitaDelegato")
				variazione?.cfsDeleg = result.string(forColumn: "codFiscDelegato")
				variazione?.stato = StatoVariazione(rawValue: result.string(forColumn: "stato") ?? "")
			}
		} catch {
			print(error)
		}
		
		return variazione
	}
	
	func getStatiVariazioni() -> [StatoVarModel]{
		var stati = [StatoVarModel]()
		let query  = "SELECT id, stato FROM Variazioni"
		do {
			let result = try self.db.executeQuery(query, values: nil)
			while result.next() {
				let stato = StatoVarModel()
				stato.idVariazione = Int(result.int(forColumn: "id"))
				stato.stato = StatoVariazione(rawValue: result.string(forColumn: "stato") ?? "")
				stati.append(stato)
			}
		} catch {
			print(error)
		}
		return stati
	}
	
	func deleteVariazione(byId id : Int){
		do{
			db.beginTransaction()
			let query = "DELETE FROM Variazioni WHERE id == '\(id)'"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
	}
    
    func saveDelegate(Variazione variazione: Variazione){
        
        deleteVariazione(byId: variazione.varId!)
        db.beginTransaction()
        let iban = "\(variazione.paese!)\(variazione.cineu!)\(variazione.cinit!)\(variazione.abi!)\(variazione.cab!)\(variazione.conto! )"
        
        let query = "INSERT INTO Variazioni (id,icon,cinBBAN,cinlBAN,cinit,paese,idTipoPagamento,codiceTipoPagamento,istituto, conto, abi, cab, cineu, idRichiedente, codSessoDelegato, nomeDelegato, cognomeDelegato, dataNascitaDelegato, provinciaNascitaDelegato, idDelegato, luogoNascitaDelegato, codFiscDelegato, stato ) values (:id,:icon,:cinBBAN,:cinlBAN,:cinit,:paese,:idTipoPagamento,:codiceTipoPagamento,:istituto,:conto,:abi,:cab,:cineu,:idRichiedente,:codSessoDelegato,:nomeDelegato,:cognomeDelegato,:dataNascitaDelegato,:provinciaNascitaDelegato,:idDelegato,:luogoNascitaDelegato,:codFiscDelegato,:stato)"

            let dict : [String:Any] = ["id":variazione.varId ?? NSNull(),
                        "icon":variazione.icon ?? NSNull(),
                        "cinBBAN": variazione.cinbban ?? NSNull(),
                        "cinlBAN": iban,
                        "cinit" : variazione.cinit ?? NSNull(),
                        "paese" : variazione.paese!,
                        "idTipoPagamento": variazione.idTipoPagamento ?? NSNull(),
                        "codiceTipoPagamento" : variazione.codtippag ?? NSNull(),
                        "istituto" : variazione.desistituto ?? NSNull(),
                        "conto" : variazione.conto ?? NSNull(),
                        "abi" : variazione.abi ?? NSNull(),
                        "cab" : variazione.cab ?? NSNull(),
                        "cineu" : variazione.cineu ?? NSNull(),
                        "idRichiedente" : variazione.idrichiedente ?? NSNull(),
                        "codSessoDelegato" : variazione.sessoDeleg ?? NSNull(),
                        "nomeDelegato" : variazione.nomeDeleg ?? NSNull(),
                        "cognomeDelegato" : variazione.cognomeDeleg ?? NSNull(),
                        "dataNascitaDelegato" : variazione.datanascitaDeleg ?? NSNull(),
                        "provinciaNascitaDelegato" : variazione.provnascitaDeleg ?? NSNull(),
                        "idDelegato" : variazione.iddelegato ?? NSNull(),
                        "luogoNascitaDelegato" : variazione.luogonascitaDeleg ?? NSNull(),
                        "codFiscDelegato" : variazione.cfsDeleg ?? NSNull(),
                        "stato" : variazione.stato != nil ? variazione.stato!.rawValue : NSNull()]

            self.db.executeUpdate(query, withParameterDictionary: dict)
            db.commit()
            
        }
    
    func updateVariazione(Variazione variazioneId: Int, byVariazione variazione: Variazione ){
        do{
            db.beginTransaction()
            let query = "UPDATE Variazioni SET cinBBAN = '\(variazione.cinbban!)', cinlBAN = '\(variazione.ciniban!)', cinit = '\(variazione.cinit!)', paese = '\(variazione.paese!)', cineu = '\(variazione.cineu!)', abi = '\(variazione.abi!)', cab = '\(variazione.cab!)', conto = '\(variazione.conto!)' WHERE id = '\(variazioneId)'"
            try self.db.executeUpdate(query, values: nil)

        }
        catch{
            print(error)
        }
        db.commit()
            
    }
    
    
    func updateTipoPagamento(Variazione variazione: Int, TipoPagamento tipoPagamento: TipoPagamento ){
        do{
            db.beginTransaction()
            let query = "UPDATE Variazioni SET idTipoPagamento = '\(tipoPagamento.id!)', codiceTipoPagamento = '\(tipoPagamento.codice!)' WHERE id = '\(variazione)'"
            try self.db.executeUpdate(query, values: nil)

        }
        catch{
            print(error)
        }
        db.commit()
            
    }
    
    func deleteDelegate(Variazione variazione: Variazione){
        
        deleteVariazione(byId: variazione.varId!)
        db.beginTransaction()
        let iban = "\(variazione.paese!)\(variazione.cineu!)\(variazione.cinit!)\(variazione.abi!)\(variazione.cab!)\(variazione.conto! )"
        
        let query = "INSERT INTO Variazioni (id,icon,cinBBAN,cinlBAN,cinit,paese,idTipoPagamento,codiceTipoPagamento,istituto, conto, abi, cab, cineu, idRichiedente,stato ) values (:id,:icon,:cinBBAN,:cinlBAN,:cinit,:paese,:idTipoPagamento,:codiceTipoPagamento,:istituto,:conto,:abi,:cab,:cineu,:idRichiedente,:stato)"

            let dict : [String:Any] = ["id":variazione.varId ?? NSNull(),
                        "icon":variazione.icon ?? NSNull(),
                        "cinBBAN": variazione.cinbban ?? NSNull(),
                        "cinlBAN": iban,
                        "cinit" : variazione.cinit ?? NSNull(),
                        "paese" : variazione.paese!,
                        "idTipoPagamento": variazione.idTipoPagamento ?? NSNull(),
                        "codiceTipoPagamento" : variazione.codtippag ?? NSNull(),
                        "istituto" : variazione.desistituto ?? NSNull(),
                        "conto" : variazione.conto ?? NSNull(),
                        "abi" : variazione.abi ?? NSNull(),
                        "cab" : variazione.cab ?? NSNull(),
                        "cineu" : variazione.cineu ?? NSNull(),
                        "idRichiedente" : variazione.idrichiedente ?? NSNull(),
                        "stato" : variazione.stato != nil ? variazione.stato!.rawValue : NSNull()]

            self.db.executeUpdate(query, withParameterDictionary: dict)
            db.commit()
            
        }
        
	
	func deleteAll(){
		do{
			db.beginTransaction()
			let query = "DELETE FROM Variazioni"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()
	}
}
