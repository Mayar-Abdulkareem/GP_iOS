//
//  AppDelegate.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 05/11/2023.
//

import UIKit
import SendbirdChatSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let initParams = InitParams(
//            applicationId: "6A40637C-F859-4DBC-86E4-15E2B553A67A",
//            isLocalCachingEnabled: true,
//            logLevel: .info
//        )
//
//        SendbirdChat.initialize(params: initParams) {
//            // Migration starts.
//        }, completionHandler: { error in
//            // Migration completed.
//        }
//        
//        SendbirdChat.connect(userId: "1") { user, error in
//            guard let user = user, error == nil else {
//                // Handle error.
//                return
//            }
//            print("connected")
//        }
//        return true
//    }

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

