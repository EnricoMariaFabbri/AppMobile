//
//  DatiFiscaliRepository.swift
//  M-JobOffice
//
//  Created by Enrico Fabbri on 08/04/2020.
//  Copyright © 2020 Stage. All rights reserved.
//

import Foundation

class DatiFiscaliRepository: BaseRepository{
    
    private let IDGPX_DACDET_FAM = "idGpxDACDetfamcarfisc"
    private let ID_ANAGRAFE_UNICA = "idAn1DACAnagrafeUnica"
    private let COD_RELAZIONE = "codiceRelazione"
    private let DES_RELAZIONE = "desRelazione"
    private let COGNOME = "cognome"
    private let NOME = "nome"
    private let SESSO = "sessoInt"
    private let DES_SESSO = "desSesso"
    private let LUOGO_NASCITA = "luogoNascita"
    private let PROV_NASCITA = "provNascita"
    private let DATA_NASCITA = "dataNascita"
    private let CFS = "cfs"
    private let FLG_CARICO = "flgCarico"
    private let FLG_INABILE = "flgInabile"
    private let FLG_STUDAPPR = "flgStudappr"
    private let PRC_CARICO = "prcCarico"
    
    func insertFamiliare(byFamiliare familiare : Familiare){
        db.beginTransaction()
        
        let query = "INSERT INTO Familiare_Carico (idGpxDACDetfamcarfisc,idAn1DACAnagrafeUnica,codiceRelazione,desRelazione,cognome,nome,sessoInt,desSesso, luogoNascita, provNascita, dataNascita, cfs, carico, inabile, studenteApprendista, percentualeCarico) values (:idGpxDACDetfamcarfisc,:idAn1DACAnagrafeUnica,:codiceRelazione,:desRelazione,:cognome,:nome,:sessoInt,:desSesso,:luogoNascita,:provNascita,:dataNascita,:cfs,:carico,:inabile,:studenteApprendista,:percentualeCarico)"
        
        //print("DATI DELLA QUERY: ", familiare.relazione.desRel ?? NSNull(), familiare.relazione.codice ?? NSNull())
        
        let dict : [String:Any] = ["idGpxDACDetfamcarfisc" : familiare.idgpx_dacdet ?? NSNull(),
                                   "idAn1DACAnagrafeUnica" : familiare.id_anagrafe ?? NSNull(),
                                   "codiceRelazione" : familiare.relazione.codice ?? NSNull(),
                                   "desRelazione" : familiare.relazione.desRel ?? NSNull(),
                                   "cognome" : familiare.cognome ?? NSNull(),
                                   "nome" : familiare.nome ?? NSNull(),
                                   "sessoInt" : familiare.sesso ?? NSNull(),
                                   "desSesso" : familiare.des_sesso ?? NSNull(),
                                   "luogoNascita" : familiare.luogo_nascita ?? NSNull(),
                                   "provNascita" : familiare.prov_nascita ?? NSNull(),
                                   "dataNascita" : familiare.data_nascita ?? NSNull(),
                                   "cfs" : familiare.cf!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   "carico" : familiare.flag_carico ?? NSNull(),
                                   "inabile" : familiare.flag_inabile ?? NSNull(),
                                   "studenteApprendista" : familiare.flag_studappr ?? NSNull(),
                                   "percentualeCarico" : familiare.prc_carico ?? NSNull()]
        
        print(dict)
        
        self.db.executeUpdate(query, withParameterDictionary: dict)
        db.commit()

    }
    
    func getFamiliari() -> [Familiare]{
        var familiari = [Familiare]()
        let query  = "SELECT * FROM Familiare_Carico"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                let familiare = Familiare()
                familiare.idgpx_dacdet = Int(result.int(forColumn: "idGpxDACDetfamcarfisc"))
                familiare.id_anagrafe = Int(result.int(forColumn: "idAn1DACAnagrafeUnica"))
                familiare.relazione.codice = Int(result.int(forColumn: "codiceRelazione"))
                familiare.relazione.desRel = result.string(forColumn: "desRelazione")
                familiare.cognome = result.string(forColumn: "cognome")
                familiare.nome = result.string(forColumn: "nome")
                familiare.sesso = Int(result.int(forColumn: "sessoInt"))
                familiare.des_sesso = result.string(forColumn: "desSesso")
                familiare.luogo_nascita = result.string(forColumn: "luogoNascita")
                familiare.prov_nascita = result.string(forColumn: "provNascita")
                familiare.data_nascita = result.string(forColumn: "dataNascita")
                familiare.cf = result.string(forColumn: "cfs")
                familiare.flag_inabile = result.bool(forColumn: "inabile")
                familiare.flag_carico = result.bool(forColumn: "carico")
                familiare.flag_studappr = result.bool(forColumn: "studenteApprendista")
                familiare.prc_carico = result.double(forColumn: "percentualeCarico")

                familiari.append(familiare)
            }
        } catch {
            print(error)
        }
        return familiari
    }
    
    
    func deleteAllFamiliari(){
        db.beginTransaction()
        let query  = "DELETE FROM Familiare_Carico "
        let dict : [String:Any] = [:]
        self.db.executeUpdate(query, withParameterDictionary: dict)
        db.commit()
    }
    
    func updateFamiliare(byFamiliare familiare : Familiare, CodiceFiscale codiceFiscale: String){
        db.beginTransaction()
        let query  = "DELETE FROM Familiare_Carico WHERE cfs = '\(codiceFiscale)' "
        let dict : [String:Any] = [:]
        self.db.executeUpdate(query, withParameterDictionary: dict)
        db.commit()
        
        //print(getComponenti())
        insertFamiliare(byFamiliare: familiare)
    }
    
    func getFamiliareCodFiscale(codFiscale codiceFiscale: String) -> Int{
        var count = 0
        let query  = "SELECT COUNT(*) AS Codice FROM Familiare_Carico WHERE cfs = '\(codiceFiscale)'"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            result.next()
            count = Int(result.int(forColumn: "Codice"))
            print(result)
        } catch {
            print(error)
        }
        return count
    }
    func insertOrUpdate(byFamiliare familiare : Familiare){
        let count = getFamiliareCodFiscale(codFiscale: familiare.cf!)
        if count == 0{
            insertFamiliare(byFamiliare: familiare)
        }else{
            updateFamiliare(byFamiliare: familiare, CodiceFiscale: familiare.cf!)
        }
    }
}
