//
//  DetrazioniRepository.swift
//  M-JobOffice
//
//  Created by Jean Paul Elleri on 08/04/2020.
//  Copyright © 2020 Stage. All rights reserved.
//

import Foundation


class DetrazioniRepository: BaseRepository {
   
    
    //QUESTO REPO PER ORA NON LO STIAMO USANDO
    
    
    func insertRel(by richiesta: Richiesta) {
        let query = "INSERT INTO Periodo_Detrazione(id, idEnte, annoFiscale, idGpxDACDetanagfis, idGpxDACAnagfis, idWorkflowInstance, meseInizio, meseFine, note, statoRichiesta, dataRichiesta, aliquotaFissa, percentualeAliquotaFissa, imponibileRedditoUlteriore, bonusDL6614, tipoBonusDL6614, bonusProduzioneReddito, famigliaNumerosa, percentualeFamigliaNumerosa, detailDownloaded) VALUES(:id, :idEnte, :annoFiscale, :idGpxDACDetanagfis, :idGpxDACAnagfis, :idWorkflowInstance, :meseInizio, :meseFine, :note, :statoRichiesta, :dataRichiesta, :aliquotaFissa, :percentualeAliquotaFissa, :imponibileRedditoUlteriore, :bonusDL6614, :tipoBonusDL6614, :bonusProduzioneReddito, :famigliaNumerosa, :percentualeFamigliaNumerosa, :detailDownloaded)"
        db.beginTransaction()
        let dictionary: [String:Any] = [ "id" : -1,
                                         "idEnte" : richiesta.id_ente ?? -1,
                                         "annoFiscale" : richiesta.anno_fiscale ?? -1,
                                         "idGpxDACDetanagfis" : richiesta.id_dacdec_anag  ?? -1,
                                         "idGpxDACAnagfis" : richiesta.id_dac_anag  ?? -1,
                                         "idWorkflowInstance" : "",
                                         "meseInizio" : richiesta.mese_inizio  ?? -1,
                                         "meseFine" : richiesta.mese_fine  ?? -1,
                                         "note" : "",
                                         "statoRichiesta" : "",
                                         "dataRichiesta" : richiesta.data_richiesta  ?? -1,
                                         "aliquotaFissa" : richiesta.flg_aliq_fissa  ?? -1,
                                         "percentualeAliquotaFissa" : richiesta.prc_aliq_fissa  ?? -1,
                                         "imponibileRedditoUlteriore" : richiesta.imp_reddult  ?? -1,
                                         "bonusDL6614" : richiesta.flg_bonus  ?? -1,
                                         "tipoBonusDL6614" : richiesta.tip_bonus  ?? -1,
                                         "bonusProduzioneReddito" : richiesta.flg_bonus_prod_reddito  ?? -1,
                                         "famigliaNumerosa" : richiesta.flg_fam_numerose  ?? -1,
                                         "percentualeFamigliaNumerosa" : richiesta.prc_fam_numerose  ?? -1,
                                         "detailDownloaded" : ""]
        self.db.executeUpdate(query, withParameterDictionary: dictionary)
        print("INSERT RICHIESTA: ", richiesta.id_ente ?? "-1")
        db.commit()
    }
    
    func getAll() -> [Dictionary<String,Any>] {
        var array = [Dictionary<String,Any>]()
        let query = "SELECT * FROM Periodo_Detrazione"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                var rel = Dictionary<String,Any>()
                rel["id"] = Int(result.int(forColumn: "id"))
                rel["idEnte"] = Int(result.int(forColumn: "idEnte"))
                rel["annoFiscale"] = Int(result.int(forColumn: "annoFiscale"))
                rel["idGpxDACDetanagfis"] = Int(result.int(forColumn: "idGpxDACDetanagfis"))
                rel["idGpxDACAnagfis"] = Int(result.int(forColumn: "idGpxDACAnagfis"))
                rel["idWorkflowInstance"] = Int(result.int(forColumn: "idWorkflowInstance"))
                rel["meseInizio"] = Int(result.int(forColumn: "meseInizio"))
                rel["meseFine"] = Int(result.int(forColumn: "meseFine"))
                rel["note"] = Int(result.int(forColumn: "note"))
                rel["statoRichiesta"] = Int(result.int(forColumn: "statoRichiesta"))
                rel["dataRichiesta"] = Int(result.int(forColumn: "dataRichiesta"))
                rel["aliquotaFissa"] = Int(result.int(forColumn: "aliquotaFissa"))
                rel["percentualeAliquotaFissa"] = Int(result.int(forColumn: "percentualeAliquotaFissa"))
                rel["imponibileRedditoUlteriore"] = Int(result.int(forColumn: "imponibileRedditoUlteriore"))
                rel["bonusDL6614"] = Int(result.int(forColumn: "bonusDL6614"))
                rel["bonusProduzioneReddito"] = Int(result.int(forColumn: "bonusProduzioneReddito"))
                rel["famigliaNumerosa"] = Int(result.int(forColumn: "famigliaNumerosa"))
                rel["percentualeFamigliaNumerosa"] = Int(result.int(forColumn: "percentualeFamigliaNumerosa"))
                rel["percentualeFamigliaNumerosa"] = Int(result.int(forColumn: "percentualeFamigliaNumerosa"))
                rel["detailDownloaded"] = Int(result.int(forColumn: "detailDownloaded"))
                
                array.append(rel)
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
            let query = "DELETE FROM Periodo_Detrazione"
            try self.db.executeUpdate(query, values: nil)
        }
        catch{
            print(error)
        }
        db.commit()

    }
 
}
