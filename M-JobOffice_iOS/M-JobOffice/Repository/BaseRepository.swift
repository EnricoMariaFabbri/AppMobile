
import UIKit
import FMDB

class BaseRepository: NSObject {

	var db : FMDatabase
	
	override init() {
		let delegate = UIApplication.shared.delegate as! AppDelegate
		db = delegate.dataBaseHelper.dataBase!
		super.init()
	}
	
}
