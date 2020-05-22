//
//  ListaAooUtenteRepository.swift
//  AppSegreteria
//
//  Created by Leonardo Canali on 27/02/17.
//  Copyright © 2017 Sama Alessandro. All rights reserved.
//

import Foundation

class ListaAooUtenteRepository: BaseRepository {
    
    
    func insertListaAooUtente(_ liste : [ListaAooUtente]) {
    
        db.beginTransaction()
        for lista in liste {
        
        
        let query = "INSERT INTO ListaAooUtente (TokenUtente,Default,Denominazione,Pkid) values (:tokenUtente,:default,:denominazione,:pkid)"
        self.db.executeUpdate(query, withParameterDictionary: ["tokenUtente": lista.tokenUtente!,
                                                               "default":lista.isDefault!,
                                                               "denominazione": lista.denominazione!,
                                                               "pkid" : lista.pkID!])
        }
        db.commit()
        
    }
    
	func deleteAll(){
		do{
			db.beginTransaction()
			let query = "DELETE FROM ListaAooUtente"
			try self.db.executeUpdate(query, values: nil)
		}
		catch{
			print(error)
		}
		db.commit()

	}
	
	
}
