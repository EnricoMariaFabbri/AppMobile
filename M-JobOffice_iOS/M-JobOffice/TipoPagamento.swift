

import Foundation

class TipoPagamento {

   
    var id : Int?
    var nome : String?
    var codice : String?
    var icon : Int?


    enum CodingKeys: String {
        
        case id = "idpagtppag"
        case nome = "destppag"
        case codice = "codtppag"
        case icon = "icona"
    }
    
    init() {/*Only for convenience*/}
    

    
    
    required init(fromJSON json: [String:Any]) {
        
        typealias k = CodingKeys
        id = json[k.id.rawValue] as? Int
        nome = json[k.nome.rawValue] as? String
        codice = json[k.codice.rawValue] as? String
        icon = json[k.icon.rawValue] as? Int != nil ? json[k.icon.rawValue] as! Int : 0
    }
    
    func toJSON() -> [String:Any]{
        typealias k = CodingKeys
        var json = [String:Any]()
        json[k.id.rawValue] = id!
        json[k.nome.rawValue] = nome!
        json[k.codice.rawValue]  = codice!
        json[k.icon.rawValue] = icon!
        
        return json
    }
        
}
