//
//  SceneDelegate.swift
//  GroceryUser
//
//  Created by osx on 21/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window = self.window
        guard let _ = (scene as? UIWindowScene) else { return }
        self.setScreen()
        
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
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

