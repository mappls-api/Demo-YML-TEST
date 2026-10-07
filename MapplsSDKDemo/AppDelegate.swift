//
//  AppDelegate.swift

//
//  Created by CE Info on 24/07/18.
//  Copyright © 2022 Mappls. All rights reserved.
//

import UIKit
import MapplsAPICore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MapplsAccountManager.setMapSDKKey("")
        MapplsAccountManager.setRestAPIKey("")
        MapplsAccountManager.setClientId("")
        MapplsAccountManager.setClientSecret("")
        MapplsAccountManager.setGrantType("") //eg.client_credentials
        
        return true
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
    }
    
    // MARK: - UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Uses the configuration defined in the Info.plist scene manifest.
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }
}

