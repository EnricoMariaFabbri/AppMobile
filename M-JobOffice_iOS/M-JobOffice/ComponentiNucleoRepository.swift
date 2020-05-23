

import Foundation

class ComponentiNucleoRepository: BaseRepository{
    
    func insertComponente(byComponente componente : FamiliareANF){
        db.beginTransaction()
        
        let query = "INSERT INTO Componenti_Nucleo (idComponenteNucleo,idAnagrafeUnica,codiceRelazione,desRelazione,cognome,nome,sessoInt,desSesso, luogoNascita, provNascita, dataNascita, cfs, familiare, inabile, orfano, studenteApprendista, redditoDipendente, redditoAltro) values (:idComponenteNucleo,:idAnagrafeUnica,:codiceRelazione,:desRelazione,:cognome,:nome,:sessoInt,:desSesso,:luogoNascita, :provNascita,:dataNascita,:cfs,:familiare,:inabile,:orfano,:studenteApprendista,:redditoDipendente,:redditoAltro)"
        
        print("DATI DELLA QUERY: ", componente.relazione.desRel ?? NSNull(), componente.relazione.codice ?? NSNull())
        
        let dict : [String:Any] = ["idComponenteNucleo":componente.idCompNucleo ?? NSNull(),
                                   "idAnagrafeUnica":componente.id_anagrafe ?? NSNull(),
                                   "codiceRelazione": componente.relazione.codice ?? NSNull(),
                                   "desRelazione" : componente.relazione.desRel ?? NSNull(),
                                   "cognome" : componente.cognome!,
                                   "nome": componente.nome ?? NSNull(),
                                   "sessoInt" : componente.sesso ?? NSNull(),
                                   "desSesso" : componente.des_sesso ?? NSNull(),
                                   "luogoNascita" : componente.luogo_nascita ?? NSNull(),
                                   "provNascita" : componente.prov_nascita ?? NSNull(),
                                   "dataNascita" : componente.data_nascita ?? NSNull(),
                                   "cfs" : componente.cf!.trimmingCharacters(in: .whitespacesAndNewlines),
                                   "familiare" : componente.flag_familiare ?? NSNull(),
                                   "inabile" : componente.flag_inabile ?? NSNull(),
                                   "orfano" : componente.flag_orfano ?? NSNull(),
                                   "studenteApprendista" : componente.flag_studappr ?? NSNull(),
                                   "redditoDipendente" : componente.reddito_dipendente ?? NSNull(),
                                   "redditoAltro" : componente.reddito_altro ?? NSNull()]
        
        self.db.executeUpdate(query, withParameterDictionary: dict)
        db.commit()
        print(dict)
    }
    
    
    func deleteAllComponenti(){
        db.beginTransaction()
        let query  = "DELETE FROM Componenti_Nucleo "
        let dict : [String:Any] = [:]
        self.db.executeUpdate(query, withParameterDictionary: dict)
        db.commit()
    }
    
    func updateComponente(byComponente componente : FamiliareANF, CodiceFiscale codiceFiscale: String){
        db.beginTransaction()
        let query  = "DELETE FROM Componenti_Nucleo WHERE cfs = '\(codiceFiscale)' "
        let dict : [String:Any] = [:]
        self.db.executeUpdate(query, withParameterDictionary: dict)
        db.commit()
        
        //print(getComponenti())
        insertComponente(byComponente: componente)
    }
    
    //gli restituisce quello che c'è tutto sul db attuale
    //aggiungi richiesta -> chiama questa funzione
    // c'è il metodo tojson dentro a componentinucleo
    func getComponenti() -> [FamiliareANF]{
        var componenti = [FamiliareANF]()
        let query  = "SELECT * FROM Componenti_Nucleo"
        do {
            let result = try self.db.executeQuery(query, values: nil)
            while result.next() {
                let componente = FamiliareANF()
                componente.idCompNucleo = Int(result.int(forColumn: "idComponenteNucleo"))
                componente.id_anagrafe = Int(result.int(forColumn: "idAnagrafeUnica"))
                componente.cod_relazione = Int(result.int(forColumn: "codiceRelazione"))
                componente.desRelazione = result.string(forColumn: "desRelazione")
                componente.cognome = result.string(forColumn: "cognome")
                componente.nome = result.string(forColumn: "nome")
                componente.sesso = Int(result.int(forColumn: "sessoInt"))
                componente.des_sesso = result.string(forColumn: "desSesso")
                componente.luogo_nascita = result.string(forColumn: "luogoNascita")
                componente.prov_nascita = result.string(forColumn: "provNascita")
                componente.data_nascita = result.string(forColumn: "dataNascita")
                componente.cf = result.string(forColumn: "cfs")
                componente.flag_familiare = result.bool(forColumn: "familiare")
                componente.flag_inabile = result.bool(forColumn: "inabile")
                componente.flag_orfano = result.bool(forColumn: "orfano")
                componente.flag_studappr = result.bool(forColumn: "studenteApprendista")
                componente.reddito_dipendente = result.double(forColumn: "redditoDipendente")
                componente.reddito_altro = result.double(forColumn: "redditoAltro")
                
                componente.relazione.desRel = result.string(forColumn: "desRelazione")
                componente.relazione.codice = Int(result.int(forColumn: "codiceRelazione"))

                componenti.append(componente)
            }
        } catch {
            print(error)
        }
        return componenti
    }
    
    func getComponenteCodFiscale(codFiscale codiceFiscale: String) -> Int{
        var count = 0
        let query  = "SELECT COUNT(*) AS Codice FROM Componenti_Nucleo WHERE cfs = '\(codiceFiscale)'"
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
    
    func insertOrUpdate(byComponente componente : FamiliareANF){
        let count = getComponenteCodFiscale(codFiscale: componente.cf!)
        if count == 0{
            componente.id_anagrafe = (self.getComponenti().last?.id_anagrafe ?? 0) + 1
            componente.idCompNucleo = (self.getComponenti().last?.idCompNucleo ?? 0) + 1
            insertComponente(byComponente: componente)
        }else{
            updateComponente(byComponente: componente, CodiceFiscale: componente.cf!)

        }
    }
}
