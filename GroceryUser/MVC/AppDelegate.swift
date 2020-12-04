//
//  AppDelegate.swift
//  GroceryUser
//
//  Created by osx on 21/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        Thread.sleep(forTimeInterval: 3)
        UINavigationBar.appearance().isHidden = true
        
        //setScreen()
        if #available(iOS 13.0, *){
            
        }else{
            
            self.setScreen()
            
        }
//        
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
    
    
}

