//
//  SettingsView.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class SettingsView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var user_Name: UINavigationItem!
    
    @IBOutlet weak var homeBase: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userData = UserDefaults.standard.value(forKey: "userData") as! Dictionary<String, String>
        
        user_Name.title = userData["fullName"]
        // Do any additional setup after loading the view.
        
        homeBase.text = userData["homebase"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        server.ref().unauth()
        
        //DELETE INFORMATION FROM SHARED DATA
        UserDefaults.standard.removeObject(forKey: "userData")
        print("Deleted local userData")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "logOut", sender: nil)
        
    }
    
    @IBAction func randomTheme(_ sender: AnyObject) {
        let navController = self.navigationController as! colorfulNavigationController
        navController.generateAppTheme()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
