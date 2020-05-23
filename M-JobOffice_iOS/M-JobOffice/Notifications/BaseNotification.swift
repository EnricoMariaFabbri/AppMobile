

import Foundation

class BaseNotification {
	
	
	var stringType = ""
	init() {
		
	}
	
	init(withDictionary dict : Dictionary<String, Any>) {
		stringType = dict["messageClass"] as! String
	}
	
}
