//
//  gatherInfoViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class gatherInfoViewController: UIViewController, UIAlertViewDelegate {
    
    let MyKeychainWrapper = KeychainWrapper()

    var holdPass: String = ""
    var holdEmail:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text=holdEmail
        passwordField.text=holdPass

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var lastField: UITextField!
    
    @IBAction func nextField(_ sender: AnyObject) { // handle text inputs
        if (sender.tag == 1){
            passwordField.becomeFirstResponder()
        } else if (sender.tag == 2){
            firstField.becomeFirstResponder()
        } else if (sender.tag == 3){
            lastField.becomeFirstResponder()
        }
    }
    

    
    
    @IBAction func join(_ sender: AnyObject) {
        
        if (self.lastField.text! == "" || self.firstField.text! == "") {
            displayBasicAlert("Error", error: "Please fill in all fields", buttonText: "Try Again")
            return
        }
        
        
        
        // send data to Firebase
        server.ref().createUser(self.emailField.text!, password: self.passwordField.text!,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    print(self.emailField.text!)
                    // There was an error creating the account
                    
                    // Something went wrong. :( determin problem
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
                    let alertView = UIAlertController(title: "Error",
                        message: errorText as String, preferredStyle:.alert)
                    let okAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                    alertView.addAction(okAction)
                    self.present(alertView, animated: true, completion: nil)
                } else {
                    let uid = result?["uid"] as? String
                    // account creation just completed successfully :)
                    
                    // The logged in user's unique identifier
                    print("User created with UID: " + uid!)
                    self.logIn()
                }
                
                
        })
        
    }
    
    func logIn(){
        server.ref().authUser(self.emailField.text!, password:self.passwordField.text!) {
            error, authData in
            if error != nil {
                // Something went wrong. :( determin problem
                
                // let them know
                let alertView = UIAlertController(title: "Account created",
                    message: "However Login failed" as String, preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.performSegue(withIdentifier: "returnLogin", sender: nil)
                    
                }
                alertView.addAction(okAction)
                
                self.present(alertView, animated: true, completion: nil)
            } else {
                // Authentication just completed successfully :)
                
                let newUser = [
                    "provider": authData?.provider,
                    "firstName": self.firstField.text,
                    "lastName": self.lastField.text,
                    "fullName": self.firstField.text! + " " + self.lastField.text!,
                    "email": self.emailField.text!
                ]
                print(newUser)
                
                // The logged in user's unique identifier
                print("Working with: " +  (authData?.uid!)!)
                                
                // Create a new user dictionary accessing the user's info
                // provided by the authData parameter

                
                // Create a child path with a key set to the uid underneath the "users" node
                server.userData().setValue(newUser)
                //self.server.childByAppendingPath("test").setValue(newUser)
                
                //save password in Keychain
                self.MyKeychainWrapper.mySetObject(self.passwordField.text, forKey:kSecValueData)
                self.MyKeychainWrapper.writeToKeychain()
                
                // save user email in device
                
                UserDefaults.standard.setValue(newUser, forKey: "userData")
                
                UserDefaults.standard.synchronize()
                
                let alertView = UIAlertController(title: "Account Created!",
                    message: "" as String, preferredStyle:.alert)
                let newAccountAction = UIAlertAction(title: "Awesome!", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.performSegue(withIdentifier: "homebase", sender: nil)
                }
                alertView.addAction(newAccountAction)
                self.present(alertView, animated: true, completion: nil)
                
            }
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
