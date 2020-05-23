
import Foundation

class Cu{
	var icona : Int?
	var id : Int?
	var anno : Int?
	var prov : String?
	
	init(fromDictionary dict : Dictionary<String,Any> ) {
	
		self.icona = (dict["icona"] as? Int) != nil ? dict["icona"] as! Int : 0
		if self.icona == 0 {print("cedolino nil icon")}
		self.id = (dict["cuId"] as? Int) != nil ? dict["cuId"] as! Int : 0
		if self.id == 0 {print("cedolino nil id")}
		self.anno = (dict["anno"] as? Int) != nil ? dict["anno"] as! Int : -1
		self.prov = (dict["prov"] as? String) != nil ? dict["prov"] as! String : "nil prov"
	}

}
