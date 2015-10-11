//
//  AppDelegate.swift
//  Homebase
//
//  Created by Justin Oroz on 10/9/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import MMX
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let server = Firebase(url: "https://homebasehack.firebaseio.com")
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        MMX.setupWithConfiguration("default")
        
        // checks Firebase login status
        server.observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user authenticated
                // check if in a homebase
//TODO
                
                
                if ( NSUserDefaults.standardUserDefaults().valueForKey("homebase") != nil){
                    let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("selectHomebase")
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                }
                
                print(authData)
            } else {
                // No user is signed in
                // go to log in screen first
                let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("loginNavigator")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
            }
        })
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

