//
//  PeriodiRepository.swift
//  M-JobOffice
//
//  Created by Jean Paul Elleri on 07/04/2020.
//  Copyright © 2020 Stage. All rights reserved.
//

import Foundation


class PeriodiRepository: BaseRepository {
    
    func insertPeriodoANF(by periodoAnf: PeriodoANF) {
        let meseInizio = (periodoAnf.meseInizio ?? -1) + 1
        let meseFine = (periodoAnf.meseFine ?? -1) + 1

        let query = "INSERT INTO PeriodoANF(id, annoInizio, annoFine, idEnte, idGpxDACNucfam, idWorkflowInstance, meseInizio, meseFine, note, statoRichiesta, dataRichiestaDettaglio, idNucleoFamiliare, detailDownloaded) VALUES(:id, :annoInizio, :annoFine, :idEnte, :idGpxDACNucfam, :idWorkflowInstance, :meseInizio, :meseFine, :note, :statoRichiesta, :dataRichiestaDettaglio, :idNucleoFamiliare, :detailDownloaded)"
        db.beginTransaction()
        let dictionary: [String:Any] = [ "id" : "",
                                         "annoInizio" : periodoAnf.annoInizio ?? -1,
                                         "annoFine" : periodoAnf.annoFine ?? -1,
                                         "idEnte" : periodoAnf.idEnte ?? -1,
                                         "idGpxDACNucfam" : periodoAnf.idGpxDACNucFam ?? -1,
                                         "idWorkflowInstance" : periodoAnf.idWorkflowInstance ?? -1,
                                         "meseInizio" : meseInizio,
                                         "meseFine" : meseFine,
                                         "note" : periodoAnf.note ?? "",
                                         "statoRichiesta" : "",
                                         "dataRichiestaDettaglio" : "",
                                         "idNucleoFamiliare" : "",
                                         "detailDownloaded" : "" ]
        self.db.executeUpdate(query, withParameterDictionary: dictionary)
        //print("INSERT PERIODOANF: ", periodoAnf)
        db.commit()
    }
    
    func getAll() -> [PeriodoANF] {
        var array = [PeriodoANF]()
        let query = "SELECT * FROM PeriodoANF"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                let periodo = PeriodoANF()
                periodo.idGpxDACNucFam = Int(result.int(forColumn: "idGpxDACNucfam"))
                periodo.idWorkflowInstance = Int(result.int(forColumn: "idWorkflowInstance"))
                periodo.idEnte = Int(result.int(forColumn: "idEnte"))
                periodo.annoInizio = Int(result.int(forColumn: "annoInizio"))
                periodo.annoFine = Int(result.int(forColumn: "annoFine"))
                periodo.meseInizio = Int(result.int(forColumn: "meseInizio"))
                periodo.meseFine = Int(result.int(forColumn: "meseFine"))
                periodo.note = result.string(forColumn: "note")
                
                array.append(periodo)
            }
        } catch {
            print(error)
        }
        return array
    }
    
    /*
    func getCod(string: String) -> Int {
        let query = "SELECT codice FROM Relazione WHERE desRelM = \(string) OR desRelF = \(string)"
        var cod = Int()
        do {
            let result = try self.db.executeQuery(query, values: nil)
            cod = Int(result.int(forColumn: "codice"))
        } catch {
            print(error)
        }
        return cod
    }
    
    func getRel(by cod: Int, isMan: Bool) -> String {
        let relM = "desRelM"
        let relF = "desRelF"
        var string = ""
        let query = "SELECT * FROM Relazione WHERE codice = \(cod)"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                string = result.string(forColumn: "\(isMan ? relM : relF)") ?? ""
            }
        } catch {
            print(error)
        }
        return string
    }
 */
    
    func deleteAll() {
        do{
            db.beginTransaction()
            let query = "DELETE FROM PeriodoANF"
            try self.db.executeUpdate(query, values: nil)
        }
        catch{
            print(error)
        }
        db.commit()

    }
}
