

import Foundation

class Ente {
	
	private let ID_ENTE = "idEnte"
	private let DES_ENTE = "desEnte"
    private let ANNO = "anno"
    private let CONTENT_TYPE = "contentType"
	
    var id_ente: Int?
    var des_ente: String?
    var anno: Int?
    var contentType: Int?
	
    init(by json: Dictionary<String,Any>) {
        id_ente = json[ID_ENTE] as? Int
        des_ente = json[DES_ENTE] as? String
        anno = json[ANNO] as? Int
        contentType = json[CONTENT_TYPE] as? Int
    }
    
    init() {
        id_ente = -1
        des_ente = ""
        anno = -1
        contentType = -1
    }
    
	
}
