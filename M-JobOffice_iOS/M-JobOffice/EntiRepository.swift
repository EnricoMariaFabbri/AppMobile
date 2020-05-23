
import Foundation

class EntiRepository: BaseRepository {
    
    func insertEnte(by ente: Ente) {
        let query = "INSERT INTO EnteANF(idEnte, descrizioneEnte, anno, contentType) VALUES(:idEnte, :descrizioneEnte, :anno, :contentType)"
        db.beginTransaction()
        let dictionary: [String:Any] = [ "idEnte" : ente.id_ente ?? -1,
                                         "descrizioneEnte" : ente.des_ente ?? "",
                                         "anno" : ente.anno ?? -1,
                                         "contentType" : ente.contentType ?? -1 ]
        self.db.executeUpdate(query, withParameterDictionary: dictionary)
        print("INSERT ENTE: ", ente)
        db.commit()
    }
    
    func getAll() -> [Ente] {
        var array = [Ente]()
        let query = "SELECT * FROM EnteANF"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                let ente = Ente()
                ente.id_ente = Int(result.int(forColumn: "idEnte"))
                ente.des_ente = result.string(forColumn: "descrizioneEnte")
                ente.anno = Int(result.int(forColumn: "anno"))
                ente.contentType = Int(result.int(forColumn: "contentType"))
                array.append(ente)
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
            let query = "DELETE FROM EnteANF"
            try self.db.executeUpdate(query, values: nil)
        }
        catch{
            print(error)
        }
        db.commit()

    }
}
