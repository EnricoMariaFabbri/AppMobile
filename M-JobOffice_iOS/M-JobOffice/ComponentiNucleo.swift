

import Foundation

class ComponentiNucleo {
    
    var idComponenteNucleo : Int?
    var relazione = Relazione()
    var idAnagrafeUnica : Int?
    var codiceRelazione : Int?
    var desRelazione : String?
    var cognome : String?
    var nome : String?
    var sessoInt : Int?
    var desSesso : String?
    var luogoNascita : String?
    var provNascita : String?
    var dataNascita : String?
    var cfs : String?
    var familiare : Bool?
    var inabile : Bool?
    var orfano : Bool?
    var studenteApprendista : Bool?
    var redditoDipendente : Double?
    var redditoAltro : Double?
    
    
    enum CodingKeys: String {
        
        case idComponenteNucleo = "idComponenteNucleo"
        case idAnagrafeUnica = "idAnagrafeUnica"
        case codiceRelazione = "codiceRelazione"
        case desRelazione = "desRelazione"
        case cognome = "cognome"
        case nome = "nome"
        case sessoInt = "sessoInt"
        case desSesso = "desSesso"
        case luogoNascita = "luogoNascita"
        case provNascita = "provNascita"
        case dataNascita = "dataNascita"
        case cfs = "cfs"
        case familiare = "familiare"
        case inabile = "inabile"
        case orfano = "orfano"
        case studenteApprendista = "studenteApprendista"
        case redditoDipendente = "redditoDipendente"
        case redditoAltro = "redditoAltro"
    }
    

    init() {}
    
    
    required init(fromJSON json: [String:Any]) throws {
        
        typealias k = CodingKeys
        idComponenteNucleo = json[k.idComponenteNucleo.rawValue] as? Int
        relazione.codice = json[k.codiceRelazione.rawValue] as? Int
        idAnagrafeUnica = json[k.idAnagrafeUnica.rawValue] as? Int
        codiceRelazione = json[k.codiceRelazione.rawValue] as? Int
        desRelazione = json[k.desRelazione.rawValue] as? String
        cognome = json[k.cognome.rawValue] as? String
        nome = json[k.nome.rawValue] as? String
        sessoInt = json[k.sessoInt.rawValue] as? Int
        desSesso = json[k.desSesso.rawValue] as? String
        luogoNascita = json[k.luogoNascita.rawValue] as? String
        provNascita = json[k.provNascita.rawValue] as? String
        cfs = json[k.cfs.rawValue] as? String
        familiare = json[k.familiare.rawValue] as? Bool
        inabile = json[k.inabile.rawValue] as? Bool
        orfano = json[k.orfano.rawValue] as? Bool
        studenteApprendista = json[k.studenteApprendista .rawValue] as? Bool
        redditoDipendente = json[k.redditoDipendente .rawValue] as? Double
        redditoAltro = json[k.redditoAltro .rawValue] as? Double
    }
    
    func toJSON() -> [String:Any]{
        //print("TOJSON FUNCTION: ", relazione.codice!)
        //print("TOJSON FUNCTION: ", relazione.desRel!)
        
        typealias k = CodingKeys
        var json = [String:Any]()
        json[k.idComponenteNucleo.rawValue] = idComponenteNucleo!
        json[k.idAnagrafeUnica.rawValue] = idAnagrafeUnica!
        json[k.codiceRelazione.rawValue]  = relazione.codice!
        json[k.desRelazione.rawValue] = relazione.desRel!
        json[k.cognome.rawValue] = cognome!
        json[k.nome.rawValue] = nome!
        json[k.sessoInt.rawValue] = sessoInt!
        json[k.desSesso.rawValue] = desSesso!
        json[k.luogoNascita.rawValue] = luogoNascita!
        json[k.provNascita.rawValue] = provNascita!
        json[k.cfs.rawValue] = cfs!
        json[k.familiare.rawValue] = familiare!
        json[k.inabile.rawValue] = inabile!
        json[k.orfano.rawValue] = orfano!
        json[k.studenteApprendista .rawValue] = studenteApprendista!
        json[k.redditoDipendente.rawValue] = redditoDipendente!
        json[k.redditoAltro.rawValue] = redditoAltro!
        
        return json
    }
}

