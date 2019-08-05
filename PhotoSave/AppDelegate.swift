//
//  AppDelegate.swift
//  PhotoSave
//
//  Created by Ritesh Arora on 5/1/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit
import Firebase
import Mixpanel
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        UserDefaults.standard.set(false, forKey: "DescScreen")

        FirebaseApp.configure()
        
        Mixpanel.initialize(token: "ee5cbccfb468aa5d1057bed59bf00189")
        Mixpanel.mainInstance().identify(distinctId: Mixpanel.mainInstance().distinctId)
        FBSDKAppEvents.activateApp()

        // Override point for customization after application launch.
        if (UserDefaults.standard.value(forKey: "first") == nil) {
            UserDefaults.standard.setValue("1", forKey: "first")
            UserDefaults.standard.setValue("5", forKey: "points")
            UserDefaults.standard.setValue(false, forKey: "AdsRemoved")
        } else {
            
        }
        UserDefaults.standard.synchronize()
        
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

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        let DescScreen = UserDefaults.standard.bool(forKey: "DescScreen")
        if DescScreen
        {
            
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Paste"), object: nil)
        }

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

