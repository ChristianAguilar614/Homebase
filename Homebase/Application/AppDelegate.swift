//
//  AppDelegate.swift
//  Homebase
//
//  Created by Justin Oroz on 10/9/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // checks Firebase login status
        server.ref().observeAuthEvent({ authData in
            if authData != nil {
                // user authenticated
                
                // create dictionary for userdata storage
                var localData: Dictionary<String, String> = Dictionary<String, String>()
                
                //save most recent server data locally
                server.userData().observeSingleEvent(of: .value, with: { snapshot in
                    
                    if (snapshot?.exists())! { //check if it has data
                        
                        // always has uid information if snapshot returns
                        localData["uid"] = server.userData().authData.uid
                        print("uid updated from Firebase")
                        
                        if (snapshot?.hasChild("email"))! {
                            let email = (snapshot?.value as AnyObject).object(forKey: "email") as! String
                            localData["email"] = email
                            print("email updated from Firebase")
                        }
                        if (snapshot?.hasChild("fullName"))! {
                            let fullName = (snapshot?.value as AnyObject).object(forKey: "fullName") as! String
                            localData["fullName"] = fullName
                            print("Full Name updated from Firebase")
                        }
                        if (snapshot?.hasChild("firstName"))! {
                            let firstName = (snapshot?.value as AnyObject).object(forKey: "firstName") as! String
                            localData["firstName"] = firstName
                            print("First Name updated from Firebase")
                        }
                        if (snapshot?.hasChild("lastName"))! {
                            let lastName = (snapshot?.value as AnyObject).object(forKey: "lastName") as! String
                            localData["lastName"] = lastName
                            print("Last Name updated from Firebase")
                        }
                        if (snapshot?.hasChild("homebase"))! {
                            let homebase = (snapshot?.value as AnyObject).object(forKey: "homebase") as! String
                            localData["homebase"] = homebase
                            print("Joined Homebase: " + homebase)
                            print("HomeBase updated from Firebase")
                        }
                        if (snapshot?.hasChild("provider"))! {
                            let provider = (snapshot?.value as AnyObject).object(forKey: "provider") as! String
                            localData["provider"] = provider
                            print("Authentication Provider updated from Firebase")
                        }
                        
                        //place the Dictionary in storage
                        UserDefaults.standard.setValue(localData, forKey: "userData")
                        UserDefaults.standard.synchronize()
                        
                    } // even if snapshot does not have data
                    
                    //select homebase if none chosen
                    if ( localData["homebase"] == nil){
                        let initialViewController = self.storyboard.instantiateViewController(withIdentifier: "selectHomebase")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    } else { //go to home page if homebase chosen
                        let initialViewController = self.storyboard.instantiateViewController(withIdentifier: "mainpage")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                    
                })
            } else {
                // No user is signed in
                // go to login page
                let initialViewController = self.storyboard.instantiateViewController(withIdentifier: "loginNavigator")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
                
                
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

