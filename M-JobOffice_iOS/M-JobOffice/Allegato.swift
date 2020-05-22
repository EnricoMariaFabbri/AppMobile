//
//  AllegatoCedolino.swift
//  M-JobOffice
//
//  Created by Leonardo Canali on 30/03/17.
//  Copyright © 2017 Stage. All rights reserved.
//

import Foundation

public class Allegato{
	
	//Keys
	private let BASE64_KEY = "contentBase64"
	private let CONTENT_TYPE_KEY = "contentType"
	private let DOCUMENT_NAME_KEY = "documentName"
	private let CONTENT_SIZE_KEY = "contentSize"
	private let MIME_TYPE_KEY = "mimeType"
	
	//Vars
	var contentBase64 = ""
	var contentType = ""
	var documentName = ""
	var contentSize = ""
	var mimeType = ""
	var arrayOfpropertyModels = [WebServiceResponseModel]()
	
	
	
	init(with arrayOfProperties : [Dictionary<String,Any>]) {
		
		for property in arrayOfProperties {
			let webServiceRespondeModel = WebServiceResponseModel(withDictionary: property)
			arrayOfpropertyModels.append(webServiceRespondeModel)
		}
		
		for propertyModel in arrayOfpropertyModels{
			switch propertyModel.field {
			case BASE64_KEY:
				contentBase64 = propertyModel.value
			case CONTENT_TYPE_KEY:
				contentType = propertyModel.value
			case DOCUMENT_NAME_KEY:
				documentName = propertyModel.value
			case CONTENT_SIZE_KEY:
				contentSize = propertyModel.value
			case MIME_TYPE_KEY:
				mimeType = propertyModel.value
			default:
				print("proprietà '\(propertyModel.field)' non gestita")
			}
		}
		
	}
	
}
