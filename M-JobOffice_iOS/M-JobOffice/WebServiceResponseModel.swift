
import Foundation
public class WebServiceResponseModel{
	
	//Keys
	let FIELD_KEY = "field"
	let VALUE_KEY = "valore"
	
	//Vars
	var field = ""
	var value = ""

	init() {
	}
	
	init(withDictionary dic : Dictionary<String,Any>) {
		
		self.field = dic[FIELD_KEY] as? String != nil ? dic[FIELD_KEY] as! String : "nil field"
		self.value = dic[VALUE_KEY] as? String != nil ? dic[VALUE_KEY] as! String : "nil value"
	}
}
