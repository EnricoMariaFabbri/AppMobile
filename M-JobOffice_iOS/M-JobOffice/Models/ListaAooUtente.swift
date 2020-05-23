

import Foundation
class ListaAooUtente {
    
    //Keys
    internal let keyPkID = "pkid"
    internal let keyDefault = "default"
    internal let keyDenominazione = "denominazione"
    

    //Vars
    public var pkID : Int?
    public var tokenUtente : String?
    public var denominazione : String?
    public var isDefault : Bool?
    
    init(JSON : Dictionary<String,Any>, token : String) {
        
        pkID = JSON[keyPkID] as? Int
        tokenUtente = token
        denominazione = JSON[keyDenominazione] as? String
        let defString = JSON[keyDefault] as! String
        if defString.uppercased() == "false".uppercased(){
            isDefault = false
        }
        else{
            isDefault = true
        }
        
    }
    
    
}
