//
//  BaseRepository.swift
//  CorghiService
//
//  Created by Sama Alessandro on 05/05/16.
//  Copyright © 2016 Sama Alessandro. All rights reserved.
//

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
