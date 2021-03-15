//
//  AppDelegate.swift
//  GroceryUser
//
//  Created by osx on 21/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import CoreLocation
import Firebase
import Messages

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
  
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var deviceTokenString = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        FirebaseApp.configure()

        //setScreen()
        if #available(iOS 13.0, *){
        }else{
            self.setScreen()
        }
        
        if #available(iOS 10.0, *) {
                 // For iOS 10 display notification (sent via APNS)
                 UNUserNotificationCenter.current().delegate = self

                 let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                 UNUserNotificationCenter.current().requestAuthorization(
                   options: authOptions,
                   completionHandler: {_,_  in })
               } else {
                 let settings: UIUserNotificationSettings =
                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                 application.registerUserNotificationSettings(settings)
               }

               application.registerForRemoteNotifications()
               
               IQKeyboardManager.shared.enable = true
               Thread.sleep(forTimeInterval: 3)
               UINavigationBar.appearance().isHidden = true
               GMSPlacesClient.provideAPIKey("AIzaSyCHLhPXla2B8BZESBtz3cgmbgwkijKIWVc")
             
               Messaging.messaging().delegate = self
        
        return true
    }
   
    func setScreen() {
        let status =  UserDefaults.standard.string(forKey:"token")
        let login = UIStoryboard.init(name: "Login", bundle: nil)
        let tabbar = UIStoryboard.init(name: "Tabbar", bundle: nil)
        let loginVC = login.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        let tabbarVC = tabbar.instantiateViewController(withIdentifier: "TabbarVC") as? TabbarVC
        
        if status != nil {
            let rootNC = UINavigationController(rootViewController: tabbarVC!)
            rootNC.isNavigationBarHidden = true
            self.window!.rootViewController = rootNC
            self.window!.makeKeyAndVisible()
        } else {
             let rootNC = UINavigationController(rootViewController: loginVC!)
             rootNC.isNavigationBarHidden = true
            self.window!.rootViewController = rootNC
            self.window!.makeKeyAndVisible()
        }
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
        
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(deviceTokenString)
        UserDefaults.standard.setValue(deviceToken, forKey: deviceTokenString)
    }
        
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator :( \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let title = userInfo["title"] as! String

        print(userInfo)
        self.scheduleNotification(title:title)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func scheduleNotification(title:String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest.init(identifier: "request", content:content, trigger: nil)
        UNUserNotificationCenter.current().add((request), withCompletionHandler: {error in
            print(error as Any)
        })
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken ?? ""))")
        UserDefaults.standard.setValue(fcmToken ?? "", forKey: "FCMToken")
        let dataDict:[String: String] = ["device_token": fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
  
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler([.alert,.sound,.badge])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        completionHandler()
    }
}
