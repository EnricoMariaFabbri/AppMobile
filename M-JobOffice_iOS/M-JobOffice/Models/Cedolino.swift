
import Foundation

class Cedolino {
	
	var icona : Int?
	var id : Int?
	var descrizione : String?
	
	init(fromDictionary dict : Dictionary<String,Any> ) {
		
		self.icona = (dict["icona"] as? Int) != nil ? dict["icona"] as! Int : 0
		if self.icona == 0 {print("cedolino nil icon")}
		self.id = (dict["cedolinoId"] as? Int) != nil ? dict["cedolinoId"] as! Int : 0
		if self.id == 0 {print("cedolino nil id")}
		self.descrizione = (dict["descrizione"] as? String) != nil ? dict["descrizione"] as! String : "nil description"
	}
}
