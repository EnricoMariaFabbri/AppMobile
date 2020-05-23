

import FMDB

class DatabaseHelper: NSObject {
   
    let CURRENT_DB_VERSION = 16
    let PRIMO_AVVIO_DOPO_INSTALLAZIONE = "PRIMO_AVVIO_DOPO_INSTALLAZIONE"
    let DB_OLD_VERSION = "DB_OLD_VERSION"
    var dataBase: FMDatabase?
    var dBDocumentPath = ""
    var databaseIsOpen = false
    
    override init() {
        super.init()
        let fileManager = FileManager.default
        
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask , true)
        let documentDirectory = paths[0] as NSString
        dBDocumentPath = documentDirectory.appendingPathComponent("jobofficedb.sqlite")
        if isNewInstall() {
            let pathDB = Bundle.main.url(forResource: "jobofficedb", withExtension: "sqlite")
            if fileManager.fileExists(atPath: dBDocumentPath) {
                do {
                    try fileManager.removeItem(atPath: dBDocumentPath)
                } catch {
                    print("Errore nella cancellazione del vecchio DataBase")
                }
            }
            
            let destinationUrl = URL(fileURLWithPath: dBDocumentPath)
            do {
                try fileManager.copyItem(at: pathDB!, to: destinationUrl)
            } catch {
                print("Errore in fase di copia del DataBase")
            }
            setOldDatabaseVersion()
        } else {
            if databaseNeedsUpdate() {
                if updateDatabaseWithOldVersion(databaseOldVersion(), newVersion: CURRENT_DB_VERSION) {
                    setOldDatabaseVersion()
                } else {
                    print("Errore aggiornamento DataBase")
                }
            }
        }
        openDatabase()
    }
    
    func updateDatabaseWithOldVersion(_ oldVersion: NSInteger,  newVersion:NSInteger) -> Bool {
        openDatabase()
        for i in oldVersion ..< newVersion {
            if i == 15 {
                self.dataBase?.beginTransaction()
                
                let Familiare_Carico = "CREATE TABLE IF NOT EXISTS 'Familiare_Carico' ('pk' integer PRIMARY KEY AUTOINCREMENT,'idGpxDACDetfamcarfisc' integer,'idAn1DACAnagrafeUnica' integer,'codiceRelazione' integer,'desRelazione' text,'cognome' text,'nome' text,'sessoInt' integer,'desSesso' text,'luogoNascita' text,'provNascita' text,'dataNascita' text,'cfs' text,'carico' integer,'inabile' integer,'studenteApprendista' integer,'percentualeCarico' real);"
                let Tipo_Pagamento = "CREATE TABLE IF NOT EXISTS 'Tipo_Pagamento'('pk' integer PRIMARY KEY AUTOINCREMENT,'id' integer,'nome' text,'codice' text,'icona' int);"
                let EnteANF = "CREATE TABLE IF NOT EXISTS 'EnteANF'('pk' integer PRIMARY KEY AUTOINCREMENT,'idEnte' integer,'contentType' integer,'descrizioneEnte' text,'anno' integer);"
                let PeriodoANF = "CREATE TABLE IF NOT EXISTS 'PeriodoANF'('pk' integer PRIMARY KEY AUTOINCREMENT,'id' integer,'annoInizio' integer,'annoFine' integer,'idEnte' integer,'idGpxDACNucfam' integer,'idWorkflowInstance' integer,'meseInizio' integer,'meseFine' integer,'note' text,'statoRichiesta' text,'dataRichiestaDettaglio' text,'idNucleoFamiliare' integer,'detailDownloaded' integer);"
                let Periodo_Detrazione = "CREATE TABLE IF NOT EXISTS 'Periodo_Detrazione'('pk' integer PRIMARY KEY AUTOINCREMENT,'id' integer,'idEnte' integer,'annoFiscale' integer,'idGpxDACDetanagfis' integer,'idGpxDACAnagfis' integer,'idWorkflowInstance' integer,'meseInizio' integer,'meseFine' integer,'note' text,'statoRichiesta' integer,'dataRichiesta' text,'aliquotaFissa' integer,'percentualeAliquotaFissa' real,'imponibileRedditoUlteriore' real,'bonusDL6614' integer,'tipoBonusDL6614' text,'bonusProduzioneReddito' integer,'famigliaNumerosa' integer,'percentualeFamigliaNumerosa' real,'detailDownloaded' integer);"
                let Componenti_Nucleo = "CREATE TABLE IF NOT EXISTS 'Componenti_Nucleo' ('pk' integer PRIMARY KEY AUTOINCREMENT,'idComponenteNucleo' integer,'idAnagrafeUnica' integer,'codiceRelazione' integer,'desRelazione' text,'cognome' text,'nome' text,'sessoInt' integer,'desSesso' text,'luogoNascita' text,'provNascita' text,'dataNascita' text,'cfs' text,'familiare' integer,'inabile' integer,'orfano' integer,'studenteApprendista' integer,'redditoDipendente' real,'redditoAltro' real);"
                
                let queries = [Componenti_Nucleo,Familiare_Carico, Tipo_Pagamento,EnteANF,PeriodoANF,Periodo_Detrazione]
                

                               
//                               "CREATE TABLE IF NOT EXISTS 'Contatti' ('pk' integer PRIMARY KEY AUTOINCREMENT,'Nominativo' text,'AppName' text,'UserName' text,'IsOnline' integer,'LastMessageDate' datetime);"]
                
                for query in queries {
                    do {
                        try dataBase?.executeUpdate(query, values: nil)
                    }catch {
                        dataBase?.rollback()
                        print(error)
                        return false
                    }
                }
                dataBase?.commit()
                return true
            }
            return true
        }
        return false
    }
        
        func openDatabase() {
            if !databaseIsOpen {
                self.dataBase = FMDatabase(path: dBDocumentPath)
                databaseIsOpen = dataBase!.open();
            }
        }
        
        func isNewInstall() -> Bool {
            let valore = UserDefaults.standard.object(forKey: PRIMO_AVVIO_DOPO_INSTALLAZIONE)
            if (valore as? Bool) != nil {
                return false
            }
            UserDefaults.standard.set(true, forKey: PRIMO_AVVIO_DOPO_INSTALLAZIONE)
            return true
        }
        
        func setOldDatabaseVersion() {
            UserDefaults.standard.set(CURRENT_DB_VERSION, forKey: DB_OLD_VERSION)
        }
        
        
        func databaseNeedsUpdate() -> Bool {
            if CURRENT_DB_VERSION > databaseOldVersion() {
                return true
            }
            return false
        }
        
        func databaseOldVersion() -> NSInteger {
            let dbOldVersion = UserDefaults.standard.integer(forKey: DB_OLD_VERSION)
            return dbOldVersion;
        }
        
}

