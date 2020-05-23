

import UIKit
import Fabric
import Crashlytics
import MMDrawerController
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
	
	var window: UIWindow?
	let dataBaseHelper : DatabaseHelper = DatabaseHelper()
	var menu : LeftDrawerTableViewController?
	var timeExpired = false
	var lastDate : Date?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		Fabric.with([Crashlytics.self])
		if Session.sharedInstance.pinEnabled != nil{
			if Session.sharedInstance.pinEnabled!{
				checkIfTimeExpired()
			}
		}
		
		//FireBase settings
//		if #available(iOS 10.0, *) {
//			// For iOS 10 display notification (sent via APNS)
//			UNUserNotificationCenter.current().delegate = self
//			
//			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//			UNUserNotificationCenter.current().requestAuthorization(
//				options: authOptions,
//				completionHandler: {_, _ in })
//			
//			
//			
//		} else {
//			let settings: UIUserNotificationSettings =
//				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//			application.registerUserNotificationSettings(settings)
//		}
//		
//		application.registerForRemoteNotifications()
		
		// [END register_for_notifications]
		//FirebaseApp.configure()
		
		// [START add_token_refresh_observer]
		// Add observer for InstanceID token refresh callback.
		
		//Dovrebbe essere stato sistuito con il nuovo metodo del delgate relativo all'aggiornamento del token.
		
		//
		//		NotificationCenter.default.addObserver(self,
		//		                                       selector: #selector(self.tokenRefreshNotification),
		//		                                       name: NSNotification.Name.InstanceIDTokenRefresh,
		//		                                       object: nil)
		
		let idLogin = "LoginViewController"
		let idStoryboard = "Main"
		let storyboard = UIStoryboard(name: idStoryboard, bundle: nil)
		if Session.sharedInstance.token != nil && Session.sharedInstance.token != ""{
			
			caricaAppunti()
		}
		else{
			let view = storyboard.instantiateViewController(withIdentifier: idLogin ) as! LoginViewController
			window?.rootViewController = view
		}
		
		return true
	}
	
	func saveLastDate(){
		lastDate = Date()
		Session.sharedInstance.lastDate = lastDate
		
	}
	
	func checkIfTimeExpired(){
		if lastDate != nil{
			let currentDate = Date()
			let timeOffset = currentDate.offset(from: lastDate!)
			if timeOffset.characters.last == "m"{
				
				let rangeText = timeOffset.index(timeOffset.startIndex, offsetBy: timeOffset.characters.count - 1 )
				let minuteString = timeOffset.substring(to: rangeText)
			
				let minuteOffset = Int(minuteString)
				if minuteOffset != nil{
					if minuteOffset! < Session.sharedInstance.logoutTime!{
						//Timer not expired
						print("Timer not expired")
					}
					else{
						//Timer expired
						print("Timer expired")
						self.timeExpired = true
					}
				}


			}
			else if timeOffset.characters.last == "s"{
				self.timeExpired = true
			}
			print(timeOffset)
		}
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
//	func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//		tokenRefreshNotification(token: fcmToken)
//	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		saveLastDate()
		self.dataBaseHelper.dataBase?.close()
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	
	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		print(notification)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		//print("MessageID : \(userInfo["gcm_message_id"]!)")
		print(userInfo)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		//print("MessageID : \(userInfo["gcm_message_id"]!)")
		print(userInfo)
	}
	
//	func application(received remoteMessage: MessagingRemoteMessage) {
//		print(remoteMessage.appData as! Dictionary<String,Any>)
//		print((remoteMessage.appData as! Dictionary<String,Any>)["message"] as! String)
//		
//		let mainDict = remoteMessage.appData as! Dictionary<String,Any>
//		let message = UtilityHelper.convertToDictionary(fromString: mainDict["message"] as! String)
//		sortNotification(fromDictionary: message!)
//		
//		
//		//		let messageDict = try JSONSerialization.jsonObject(with: dataString, options: .mutableContainers) as! Dictionary<String,Any>
//		
//		//		let decodedString = String.init(data: (data as Data), encoding: String.Encoding.isoLatin1)
//		//		let dataString = decodedString?.data(using: String.Encoding.utf8)
//		//		let dict = try JSONSerialization.jsonObject(with: dataString!, options: .mutableContainers) as! Dictionary<String,Any>
//		
//	}
	
	func sortNotification(fromDictionary dict : Dictionary<String,Any>){
		
		var notification = BaseNotification()
		var type : NotificationsTypeEnum?
		let stringType = dict["MessageClass"] as! String
		switch stringType  {
		case NotificationsTypeEnum.MSGCHAT.rawValue:
			type = NotificationsTypeEnum.MSGCHAT
			notification = MsgChat(withDictionary: dict)
		default:
			break
		}
		
	}
	
	
	func tokenRefreshNotification(token : String) {
//		if let refreshedToken = InstanceID.instanceID().token() {
//			print("InstanceID token: \(refreshedToken)")
//			Session.sharedInstance.tokenGCM = refreshedToken
//		}
		Session.sharedInstance.tokenGCM = token
		connectToFcm()
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		// print(String.init(data: deviceToken, encoding: .utf8)!)
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox)
        //Messaging.messaging().apnsToken = deviceToken
		if let token = InstanceID.instanceID().token() {
			Session.sharedInstance.tokenGCM = token
		}
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		self.dataBaseHelper.dataBase?.open()
		UIApplication.shared.applicationIconBadgeNumber = 0
		connectToFcm()
		if Session.sharedInstance.pinEnabled != nil{
			if Session.sharedInstance.pinEnabled!{
				checkIfTimeExpired()
				
			}
		}
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		self.dataBaseHelper.dataBase?.close()
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print(error)
		saveLastDate()
	}
	
	func connectToFcm() {
		// Won't connect since there is no token
		guard InstanceID.instanceID().token() != nil else {
			return;
		}
		
		// Disconnect previous FCM connection if it exists.
//		Messaging.messaging().shouldEstablishDirectChannel = false
//		//Connect again (?)
//		Messaging.messaging().shouldEstablishDirectChannel = true
		
		//Deprecated :
		
		//		Messaging.messaging().connect { (error) in
		//			if error != nil {
		//				print("Unable to connect with FCM. \(error)")
		//			} else {
		//				print("Connected to FCM.")
		//			}
		//		}
	}
	
	func logout(){
		
		Session.sharedInstance.deleteAll()
		let idStoryboard = "Main"
		let storyboard = UIStoryboard(name: idStoryboard, bundle: nil)
		let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
		window?.rootViewController = loginViewController
	}
	
	
	func caricaAppunti() {
		
		let idStoryboard = "Main"
		let storyboard = UIStoryboard(name: idStoryboard, bundle: nil)
		
		let leftViewController = storyboard.instantiateViewController(withIdentifier: "menu") as! LeftDrawerTableViewController
		(UIApplication.shared.delegate as! AppDelegate).menu = leftViewController
		let listaViewController = storyboard.instantiateViewController(withIdentifier: "cedolini") as! CedoliniViewController
		let centerViewController = UINavigationController(rootViewController: listaViewController)
		centerViewController.isNavigationBarHidden = true
		let drawerController = MMDrawerController(center: centerViewController, leftDrawerViewController: leftViewController)
		
		
		drawerController?.setDrawerVisualStateBlock { (drawerController, drawerSide, percentVisible) in
			let block : MMDrawerControllerDrawerVisualStateBlock? = MMDrawerVisualState.parallaxVisualStateBlock(withParallaxFactor: 5.0)
			if block != nil {
				block!(drawerController,drawerSide,percentVisible)
			}
		}
		drawerController?.shouldStretchDrawer = false
		drawerController?.openDrawerGestureModeMask = MMOpenDrawerGestureMode()
		drawerController?.closeDrawerGestureModeMask = .all
		drawerController?.shadowOffset = CGSize(width: -5.0, height: 40)
		drawerController?.shadowColor = UIColor.lightGray
		drawerController?.shadowRadius = 5
		
		
		if IS_IPHONE {
			let navigationController = UINavigationController(rootViewController: drawerController!)
			navigationController.isNavigationBarHidden = true
			window?.rootViewController = navigationController
		} else {
			let container = storyboard.instantiateViewController(withIdentifier: "containerVC") as! ContainerViewController
			let dettaglioViewController = (storyboard.instantiateViewController(withIdentifier: "whiteInitialDetailView"))
			container.initializeSplit(by: drawerController!, and: dettaglioViewController)
			let navigationController = UINavigationController(rootViewController: container)
			navigationController.isNavigationBarHidden = true
			window?.rootViewController = navigationController
		}
	}
	
	
}




