//
//  AppDelegate.swift
//  FireBasePushNotification
//
//  Created by Welcome on 13/09/18.
//  Copyright © 2018 Welcome. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseMessaging
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    //let notificationDelegate = SimpleNotificationDelegate()
    var networkErrorView = UIView()
    
    var fcm_token = ""
    //Define Static data
    let UUID = "1234_UDID"
    let platform_Type = "ios_device"
    let user_ID = "111111"
    //let fcmId = "cI_Ozf7ubEQ:APA91bEFQJ6Dhceyh-oFzgb8FOyfArW3aeOtIQDkrhnwwyYVl-SKE51vJOS4I3414EY7DcilBYl7R1DA23ACzmcaiCa8oO6curkht_Z9PSC_lwq5R7zKxKN0-k5RbkvYUx8bT9-_HwLM"
    let device_token = ""
    let url = "https://staging.mygov.in/api/1.0/_device_info"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ granted, error in }
        } else { // iOS 9 support
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        application.registerForRemoteNotifications()
        //Setting the delegate to self for Firebase to receieve the notification and  performing delegate methods
        //  self.configureNotification()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    
    func configureNotification() {
        
        if #available(iOS 10.0, *) {
            
            
            //let actionReadLater = UNNotificationAction(identifier: Notification.Action.readLater, title: "Read Later", options: [])
            
            
            /*  let openAction = UNNotificationAction(identifier: "OpenNotification", title: "Read Later", options: [.foreground])
             let CancelAction = UNNotificationAction(identifier: "CancelNotification", title: "Cancel", options: [.destructive])
             let DismissAction = UNNotificationAction(identifier: "DismissNotification", title: "Dismiss", options: [.destructive])
             
             
             let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction,CancelAction,DismissAction], intentIdentifiers: [], options: [])
             center.setNotificationCategories(Set([deafultCategory]))
             
             UNUserNotificationCenter.current().setNotificationCategories([deafultCategory])
             
             //let categories:NSSet = NSSet(object: deafultCategory)
             //UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: categories as? Set<UIUserNotificationCategory>))*/
            
        }
    }
    
    
    //MARK : Firebase Messaging Delegate Methods(Metgod Swizzling..Swizzle the default did register method)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        fcm_token = fcmToken
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        // TODO: If necessary send token to application server.
        SendData_API(url: self.url, fcm_ID: self.fcm_token)
        
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    //MARK: Remote Notification Method
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        
        
        // Print full message.
        print(userInfo)
        print(userInfo["attachment-url"] as! String)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcm.message_id] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            
            //Navigating to coressponding view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Notifi")
            
            // window?.rootViewController? = vc
            if let tabBarController = self.window!.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
    
    
    
    //MARK:- Network Check
    
    func NetworkCheck(){
        /*
         let alert = UIAlertController(title: "Alert", message: "Please  check internet connection.", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
         self.window?.rootViewController?.present(alert, animated: true, completion: nil)
         
         */
        networkErrorView.removeFromSuperview()
        let window = UIApplication.shared.keyWindow!
        networkErrorView = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
        window.addSubview(networkErrorView);
        networkErrorView.backgroundColor = UIColor.white
        let v2 = UIImageView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: 40))
        v2.backgroundColor = UIColor.white
        v2.image = UIImage(named: "thumbnail.asp")
        v2.contentMode = .scaleAspectFit
        networkErrorView.addSubview(v2)
        
        
        let button = UIButton(frame: CGRect(x: window.frame.origin.x, y: window.frame.height-40, width: window.frame.width, height: 40))
        button.backgroundColor = UIColor.white
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        networkErrorView.addSubview(button)
        window.addSubview(networkErrorView)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let webCnctn = WebConnectionViewController()
        if webCnctn.isConnectedToNetwork()
        {
            networkErrorView.removeFromSuperview()
            self.window?.rootViewController?.viewDidLoad()
        }
    }
    
    
    
    //MARK:- Send Data to server
    func SendData_API(url: String,fcm_ID :String) {
        
        let postObject = ["gcm_id":fcm_ID,"user_id":user_ID,"platform_type":platform_Type,"uuid":UUID,"device_id" : self.device_token] as [String: Any]
        print(postObject)
        let webCnctn = WebConnectionViewController()
        webCnctn.downloadData(fromUrl: url, isAuthenticRequest: false, postObject: postObject, requestType: "POST", compHandler:{ data, error in
            if (error != nil) {
            }
            else{
                print(data ?? "value")
                let dataString = String.init(data: data!, encoding: String.Encoding.utf8)
                print("Data encoded string is :\(String(describing: dataString))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                        
                        print("Data is -\(json)")
                    }
                    else{
                        
                    }
                } catch let error {
                    
                    print(error.localizedDescription)
                    
                }
            }
        })
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FireBasePushNotification")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    //MARK:- Custom Loader Methods
    
    func showLoader(withText text : String , onView : UIView) -> () {
        //AcustomActivityLoader.shared().beginAnimation(withText: text, on: window)
        MBProgressHUD.showAdded(to: onView, animated: true)
    }
    func change(text : String) -> () {
       // AcustomActivityLoader.shared().changeText(text)
    }
    func hideLoader(onView : UIView) -> () {
      MBProgressHUD.hide(for: onView, animated: true)
    }
}
    
    // Shared Appdelegate
    var shareDeleagte: AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    

