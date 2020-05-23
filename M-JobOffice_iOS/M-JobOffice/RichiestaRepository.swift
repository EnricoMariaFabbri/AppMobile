
import Foundation


class RichiestaRepository: BaseRepository {
   
    
    
    
    
    
    
    
    //bisogna correggere table Periodo_Detrazione e mettere gli stessi campi di richiestaANF?
    
    
    
    
    
    
    
    
    func insertRichiesta(by richiesta: RichiestaANF) {
        let query = "INSERT INTO Periodo_Detrazione(idNucleoFamiliare, idEnte, dataRichiesta, annoInizio, annoFine, meseInizio, meseFine, componentiNucleo) VALUES(:idNucleoFamiliare, :idEnte, :dataRichiesta, :annoInizio, :annoFine, :meseInizio, :meseFine)"
        db.beginTransaction()
        let dictionary: [String:Any] = [ "idNucleoFamiliare" : richiesta.id_nucleo ?? -1,
                                         "idEnte" : richiesta.id_ente ?? -1,
                                         "dataRichiesta" : richiesta.data_richiesta ?? -1,
                                         "annoInizio" : richiesta.anno_inizio  ?? -1,
                                         "annoFine" : richiesta.anno_fine  ?? -1,
                                         "meseInizio" : richiesta.mese_inizio  ?? -1,
                                         "meseFine" : richiesta.mese_fine  ?? -1 ]
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
                rel["idNucleoFamiliare"] = Int(result.int(forColumn: "idNucleoFamiliare"))
                rel["idEnte"] = Int(result.int(forColumn: "idEnte"))
                rel["dataRichiesta"] = Int(result.int(forColumn: "dataRichiesta"))
                rel["annoInizio"] = Int(result.int(forColumn: "annoInizio"))
                rel["annoFine"] = Int(result.int(forColumn: "annoFine"))
                rel["meseInizio"] = Int(result.int(forColumn: "meseInizio"))
                rel["meseFine"] = Int(result.int(forColumn: "meseFine"))
                
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
