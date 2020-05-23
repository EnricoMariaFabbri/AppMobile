

import AFNetworking
import RxSwift

private let sharedWebService = WebService()

class WebService: NSObject {
	
	class var sharedInstance: WebService {
		return sharedWebService
	}
	
	fileprivate let WEB_SERVICE_URL = Session.sharedInstance.SMACUrl != nil ? Session.sharedInstance.SMACUrl! : "http://smac.maggiolicloud.it/smac/"
	
	fileprivate func postToMethod (_ methodName: String, params:Dictionary<String,Any>?, entryPoint:String = ENTRY_POINT_DEFAULT) -> Observable<AnyObject?> {
		var dictionary = Dictionary<String,Any>()
		if params != nil {
			dictionary = params!
		}
		
		if entryPoint != ENTRY_POINT_ACTIVATE && entryPoint != ENTRY_POINT_SET_STATUS {
			dictionary["token"] = Session.sharedInstance.token!
		}
		dictionary["mobileId"] = Session.sharedInstance.deviceID
		
		print(dictionary)
		
		return Observable.create{ observer in
			var url = ""
			
			if Session.sharedInstance.isSMACEnabled!{
				url = "\(WebService.sharedInstance.WEB_SERVICE_URL)\(entryPoint)"
			}else{
				url = Session.sharedInstance.servletUrl!
			}
			
			let serializer = AFJSONRequestSerializer()
			serializer.setValue("APP", forHTTPHeaderField: "Maggioli-SMC-Source-System")
			if !Session.sharedInstance.isSMACEnabled!{
				serializer.setValue(Session.sharedInstance.j2Username!, forHTTPHeaderField: "Maggioli-SMC-J2EE-Username")
				serializer.setValue(Session.sharedInstance.j2Username!, forHTTPHeaderField: "Maggioli-SMC-J2EE-Password")
				serializer.setValue("TransactionID", forHTTPHeaderField: "Maggioli-SMC-Transaction-ID")
			}
			serializer.setValue(DateHelper.stringDataEOraForWebService(Date()), forHTTPHeaderField: "Maggioli-SMC-Sent-Date")
			serializer.setValue("synchronous", forHTTPHeaderField: "Maggioli-SMC-Message-Handling")
			serializer.setValue("1", forHTTPHeaderField: "Maggioli-SMC-Message-Version")
			serializer.setValue(methodName, forHTTPHeaderField: "Maggioli-SMC-Message-Class")
			var error: NSError?
			let urlRequest = serializer.request(withMethod: "POST", urlString: url, parameters: dictionary, error: &error)
			let operation = AFHTTPRequestOperation.init(request: urlRequest as URLRequest)
			operation.responseSerializer = AFHTTPResponseSerializer()
			operation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
				let data = responseObject as! NSData
				do {
					let decodedString = String.init(data: (data as Data), encoding: String.Encoding.utf8)
					print(decodedString)
					let dataString = decodedString?.data(using: String.Encoding.utf8)
					let dict = try JSONSerialization.jsonObject(with: dataString!, options: .mutableContainers) as! Dictionary<String,Any>
					if dict["resultCode"] == nil || dict["resultCode"] as? Int == 0 {
						observer.onNext(dict as AnyObject?)
						observer.onCompleted()
					} else {
						let customError = NSError(domain: "", code: 0, userInfo: dict)
						observer.onError(customError)
					}
					
				} catch {
					print(error)
				}
			}, failure: { (operation, error) -> Void in
				print("Error: \(error)");
				observer.onError(error)
			})
			operation.start()
			
			return Disposables.create {
				operation.cancel()
			}
		}
	}

    func getVociMenuTimbrature() -> Observable<AnyObject?> {
        return postToMethod("krn.smc.appmenu.elenco", params: nil)
    }
	func anniCartellini() -> Observable<AnyObject?> {
		return postToMethod("krn.smc.cartelli.anni", params: nil)
	}
	func getCartellini(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("krn.smc.cartelli.elenco", params: params)
	}
	func downloadCartellino(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("krn.smc.cartelli.download", params: params)
	}
	func getTipiPagamento() -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.var.tipag", params: nil)
	}
	func getVariazioni() -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.var.elenco", params: nil)
	}
	func setStatus(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("", params: params, entryPoint: ENTRY_POINT_SET_STATUS)
	}
	func addNewVariazione(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.var.setrich", params: params)
	}
	func attivazioneDispositivo(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("cmn.smc.attivazione.dispositivo", params: params, entryPoint: ENTRY_POINT_ACTIVATE)
	}
	func deleteVariazione(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.var.delrich", params: params)
	}
	func chackAbiCab(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.var.verbanca", params: params)
	}

	func getPeriodi() -> Observable<AnyObject?> {
			return postToMethod("gpx.smc.detrfisc.elenco", params: nil)
	}
	
	func getPeriodiANF() -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.anf.elenco", params: nil)
	}
	
	func getEnti(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.enti.elenco", params: params)
	}
	
	func getNuoviPeriodi(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.detrfisc.newperiodo", params: params)
	}
	
	func getNuoviPeriodiANF(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.anf.newperiodo", params: params)
	}
	
	func getDettaglioDetrazione(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
        print("gpx.smc.anf.setrich - CHIAMATA PER addDetrazioneANF: ", params)
		return postToMethod("gpx.smc.detrfisc.periodo", params: params)
	}
	
	func getDettaglioDetrazioneANF(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.anf.periodo", params: params)
	}
	
	func deleteDetrazione(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.detrfisc.delrich", params: params)
	}
	
	func deleteDetrazioneANF(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.anf.delrich", params: params)
	}
	
	func addDetrazione(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.detrfisc.setrich", params: params)
	}
	
	func addDetrazioneANF(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
        print("gpx.smc.anf.setrich - CHIAMATA PER addDetrazioneANF: ", params)
		return postToMethod("gpx.smc.anf.setrich", params: params)
	}
	func getRelazioni() -> Observable<AnyObject?> {
		return postToMethod("gpx.smc.utils.relpar", params: nil)
	}
	func getCartelliniUtente(_ params:Dictionary<String,Any>) -> Observable<AnyObject?> {
		return postToMethod("krn.smc.cartelli.gestcartellini", params: params)
	}
    
    //---------------------------------Nuovi Sottoscrittori-------------------------------------
    
    //------------------------------------Menu--------------------------------------------------
    func elencoMenuSubscriptor() -> Observable<AnyObject?> {
        return postToMethod("gpx.smc.appmenu.elenco", params: nil)
    }
    //---------------------------------Cedolini-------------------------------------------------
    func cedoliniSubscriptor(byAnni anni:String)-> Observable<AnyObject?>{
        var params = Dictionary<String,Any>()
        params["function"] = anni
        return postToMethod("gpx.smc.cedolini", params: params)
    }
    func cedoliniSubscriptor(byElenco elenco:String, _ params:Dictionary<String,Any>)-> Observable<AnyObject?>{
        var parametri = params
        parametri["function"] = elenco
        return postToMethod("gpx.smc.cedolini", params: parametri)
    }
    func cedoliniSubscriptor(byDownload download:String, _ params:Dictionary<String,Any>)-> Observable<AnyObject?>{
        var parametri = params
        parametri["function"] = download
        return postToMethod("gpx.smc.cedolini", params: parametri)
    }
    //---------------------------------CU-------------------------------------------------------
    func cuSubscriptor(byElenco download:String)-> Observable<AnyObject?>{
        var params = Dictionary<String,Any>()
        params["function"] = download
        return postToMethod("gpx.smc.certunica", params: params)
    }
    func cuSubscriptor(byDownload download:String, _ params:Dictionary<String,Any>)-> Observable<AnyObject?>{
        var parametri = params
        parametri["function"] = download
        return postToMethod("gpx.smc.certunica", params: parametri)
    }
    //------------------------------------------------------------------------------------------

    
    
}




