//
//  LogInViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase


class LogInViewController: UIViewController {
    
    // get server object
    let MyKeychainWrapper = KeychainWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check for Firebase login info
        //      fname
        //      lname

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func nextField(_ sender: AnyObject) {
        passwordField.becomeFirstResponder()
    }
    // submit information
    @IBAction func submit(_ sender: AnyObject) {
        
        // obvious invalid data shows alert, doesnt log in
        if (emailField.text == "" || passwordField.text == "" || emailField.text?.contains("@") == false)  {
            let alertView = UIAlertController(title: "Error",
                message: "Invalid Login" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            return;
        }
        
        // check login data against firebase
        server.ref().authUser(emailField.text, password: passwordField.text) {
            error, authData in
            if error != nil {
                var errorText: String = "Something went wrong"
                
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .userDoesNotExist:
                        errorText = "Invalid Username"
                        print("Handle invalid user")
                    case .invalidEmail:
                        errorText = "Invalid Email"
                        print("Handle invalid email")
                    case .invalidPassword:
                        errorText = "Invalid Password"
                        print("Handle invalid password")
                    default:
                        errorText = "Something went wrong"
                        print("Handle default situation")
                    }
                }
                
                // let them know
                self.displayBasicAlert("Error", error: errorText, buttonText: "Try Again")
                
            } else {
                // user is logged in, check authData for data
                
                
                //save password in Keychain
                self.MyKeychainWrapper.mySetObject(self.passwordField.text, forKey:kSecValueData)
                self.MyKeychainWrapper.writeToKeychain()
                
                // save inputted data locally
                var localData = [
                    "email": self.emailField.text,
                    "uid": server.ref().authData.uid
                ]
                print("email Saved Locally")
                print("UID Saved Locally")
                
                //save most recent server data locally
                server.userData().observeSingleEvent(of: .value, with: { snapshot in
                    
                    if (snapshot?.exists())! { //check if it has data
                        
                        
                        
                        if (snapshot?.hasChild("fullName"))! {
                            let fullName = (snapshot?.value as AnyObject).object(forKey: "fullName") as! String
                            localData["fullName"] = fullName
                            print("Full Name Saved Locally")
                        }
                        if (snapshot?.hasChild("firstName"))! {
                            let firstName = (snapshot?.value as AnyObject).object(forKey: "firstName") as! String
                            localData["firstName"] = firstName
                            print("First Name Saved Locally")
                        }
                        if (snapshot?.hasChild("lastName"))! {
                            let lastName = (snapshot?.value as AnyObject).object(forKey: "lastName") as! String
                            localData["lastName"] = lastName
                            print("Last Name Saved Locally")
                        }
                        if (snapshot?.hasChild("homebase"))! {
                            let homebase = (snapshot?.value as AnyObject).object(forKey: "homebase") as! String
                            localData["homebase"] = homebase
                            print("Joined Homebase: " + localData["homebase"]!!)
                            print("HomeBase Saved Locally")
                        }
                        if (snapshot?.hasChild("provider"))! {
                            let provider = (snapshot?.value as AnyObject).object(forKey: "provider") as! String
                            localData["provider"] = provider
                            print("Authentication Provider Saved Locally")
                        }
                        
                        UserDefaults.standard.setValue(localData, forKey: "userData")
                        UserDefaults.standard.synchronize()
                        
                    } // even if snapshot does not have data
                    
                    // if user has not selected a Homebase, force to selection screen
                    if ( UserDefaults.standard.value(forKeyPath: "userData/homebase") != nil) {
                        //if in a homebase, go home
                        print("Homebase selected, going home")
                        self.performSegue(withIdentifier: "goodLogin", sender: nil)
                    } else {
                        // else force join one
                        print("Homebase NOT selected, select one now")
                        self.performSegue(withIdentifier: "noHomeBase", sender: nil)
                    }
                    
                })
                

                
                UserDefaults.standard.synchronize()
            }
        }

    }
    // background taps dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "getMoreInfo"){ //pass forward filled data
            let info = segue.destination as! gatherInfoViewController
            info.holdPass = passwordField.text!
            info.holdEmail = emailField.text!
        }
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
