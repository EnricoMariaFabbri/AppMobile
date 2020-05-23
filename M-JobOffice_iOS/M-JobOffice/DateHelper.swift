

import UIKit

class DateHelper: NSObject {

//	static func stringFromData(data:NSDate) -> String {
//		let dateFormatter = NSDateFormatter()
//		dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
//		return dateFormatter.stringFromDate(data);
//	}
	
	static func stringDataEOraForWebService(_ data: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
		return dateFormatter.string(from: data);
	}
	
	static func stringDateFromPickerDate(_ data: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.string(from: data);
	}
	
	static func getCurrentYear() -> Int {
		let currentDateTime = Date()
		let userCalendar = Calendar.current
		let requestedComponents: Set<Calendar.Component> = [
			.year,
			.month,
			.day,
			.hour,
			.minute,
			.second
		]
		let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
		return dateTimeComponents.year!
	}
	
	static func getNumberBy(month: String) -> Int{
		switch month.uppercased() {
		case "GENNAIO": return 1
		case"FEBBRAIO": return 2
		case"MARZO":return 3
		case"APRILE":return 4
		case"MAGGIO":return 5
		case"GIUGNO":return 6
		case"LUGLIO":return 7
		case"AGOSTO":return 8
		case"SETTEMBRE":return 9
		case"OTTOBRE":return 10
		case"NOVEMBRE":return 11
		case"DICEMBRE":return 12
		default: break
		}
		return 0
	}
	
	static func getMonthBy(number: Int) -> String{
		switch number {
		case 1: return "GENNAIO"
		case 2: return "FEBBRAIO"
		case 3: return "MARZO"
		case 4: return "APRILE"
		case 5: return "MAGGIO"
		case 6: return "GIUGNO"
		case 7: return "LUGLIO"
		case 8: return "AGOSTO"
		case 9: return "SETTEMBRE"
		case 10: return "OTTOBRE"
		case 11: return "NOVEMBRE"
		case 12: return "DICEMBRE"
			default: return ""
		}
	}
	
	static func getCurrentDateCustomed(data: Date? = nil) -> String {
		var date = Date()
		if data != nil {
			date = data!
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		let dateFormatter2 = DateFormatter()
		dateFormatter2.dateFormat = "yyyy-MM-dd"
		var stringDate = String(describing: (date as NSDate))
		let range = stringDate.index(stringDate.endIndex, offsetBy: -15)..<stringDate.endIndex
		stringDate.removeSubrange(range)
		let date1 = dateFormatter2.date(from: stringDate)
		let string = dateFormatter.string(from: date1!)
		return string
	}
	
	static func getArrayMonths() -> [String] {
		return ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"]
	}
}
