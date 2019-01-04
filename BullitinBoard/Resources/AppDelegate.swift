//
//  AppDelegate.swift
//  BullitinBoard
//
//  Created by Greg Hughes on 12/31/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.registerForRemoteNotifications()
        
        MessageController.shared.subscribeToNewMessages { (success) in
            print(success)
        }
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (status, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                return
            }
            
            guard status != .granted else {print("permissionGranted") ; return}
            //checks to see if weve asked for permission in the past
            
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability, completionHandler: { (permissionStatus, error) in
                if let error = error {
                    print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                    return
                }
                print(permissionStatus)
            })
        }
        
        
//        MessageController.shared.saveMessageToCloudKit(text: "Hello") { (message) in
//            print(message?.text ?? "message didnt save")
//
//        }
//        MessageController.shared.fetchAllMessagesFromCloudKit { (messages) in
//            print(messages ?? [])
//        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let tabBarController = window?.rootViewController as? UITabBarController
        guard let messageVC = tabBarController?.viewControllers?.first as? MessageListTableViewController else { return }
        
        messageVC.fetchAndDisplayMessages()
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
    }


}


