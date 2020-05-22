//
//  QRCodeModel.swift
//
//  Created by Sama Alessandro on 09/09/16
//  Copyright (c) . All rights reserved.
//

import Foundation


open class QRCodeModel: NSObject {

    // MARK: Declaration for string constants to be used to decode and also serialize.
//	internal let kQRCodeModelAliasKey: String = "alias"
//	internal let kQRCodeModelInstitutionIdKey: String = "institutionId"
	internal let kQRCodeModelSicrawebUsernameKey: String = "sicrawebUsername"
	internal let kQRCodeModelJ2eeUserNameKey: String = "ju"
	internal let kQRCodeModelJ2eePasswordKey: String = "jp"
//	internal let kQRCodeModelUrlKey: String = "url"
	internal let kQRCodeModelTokenKey: String = "token"
	internal let kQRCodeModelServletKey: String = "servlet"


    // MARK: Properties
//	open var alias: String?
//	open var institutionId: String?
	open var sicrawebUsername: String?
	open var j2eeUserName: String?
//	open var url: String?
	open var token: String?


      /**
    Initates the class based on the JSON that was passed.
    - parameter json: JSON object from SwiftyJSON.
    - returns: An initalized instance of the class.
    */
    public init(json: NSDictionary) {
		if json["smac"] as? String != nil {
			Session.sharedInstance.SMACUrl = "\((json["smac"] as! String))/"
		}
		if json["servlet"] as? String != nil{
			Session.sharedInstance.isSMACEnabled = false
			Session.sharedInstance.servletUrl = (json["servlet"] as! String)
			Session.sharedInstance.j2Username = (json[kQRCodeModelJ2eeUserNameKey] as! String)
			Session.sharedInstance.j2password = (json[kQRCodeModelJ2eePasswordKey] as! String)
		}else{
			Session.sharedInstance.isSMACEnabled = true
		}
		
		sicrawebUsername = json[kQRCodeModelSicrawebUsernameKey]! as? String
		token = json[kQRCodeModelTokenKey]! as? String
    }

    
    
    
}
