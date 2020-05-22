//
//  MsgChat.swift
//  AppSegreteria
//
//  Created by Leonardo Canali on 10/03/17.
//  Copyright © 2017 Sama Alessandro. All rights reserved.
//

import Foundation

class MsgChat : BaseNotification{
	
	public var infoType : String = NotificationsTypeEnum.MSGCHAT.rawValue
	
	var fromUsername : String?
	var fromId : String?
	var fromDesc : String?
	var text : String?
	var date : String?

	override init(withDictionary dict : Dictionary<String,Any>) {
		
		super.init()
		self.fromUsername = dict["fromUsername"] as? String != nil ? dict["fromUsername"] as! String : "From nil username"
		self.fromUsername = dict["fromID"] as? String != nil ? dict["fromID"] as! String : "From nil id"
		self.fromUsername = dict["fromDesc"] as? String != nil ? dict["fromDesc"] as! String : "From nil description"
		self.fromUsername = dict["text"] as? String != nil ? dict["text"] as! String : "Received nil text"
		self.fromUsername = dict["date"] as? String != nil ? dict["date"] as! String : "Received nil date"
		
	}
	
	
}
