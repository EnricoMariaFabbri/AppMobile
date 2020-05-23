

import UIKit

class ErrorManager: NSObject {
	
	static func presentError(error: NSError, vc: UIViewController) {
		switch error.code {
		case -1009: UtilityHelper.presentAlertMessage(OFFLINE, message: OFFLINE_ERROR_MESSAGE, viewController: vc)
			break
		case -1001: UtilityHelper.presentAlertMessage(TOKEN, message: TOKEN_EXPIRED_MESSAGE, viewController: vc)
		case 0:
			if String(describing: error).contains(SERVER_ERROR) {
				UtilityHelper.presentAlertMessage(SERVER, message: SERVER_ERROR_MESSAGE, viewController: vc)
			}
			break
		default: UtilityHelper.presentAlertMessage("errore sconosciuto", message: "\(String(describing: error))", viewController: vc)
		}
	}
	
}
