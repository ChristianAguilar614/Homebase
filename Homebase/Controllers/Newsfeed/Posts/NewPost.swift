//
//  NewPost.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class NewComment: UIViewController, UITextViewDelegate {
    
    let userData = UserDefaults.standard.value(forKey: "userData") as! Dictionary<String, String>
    
    var thePostInfo = PostData()
    
    @IBOutlet weak var postText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        setupTextView()
        postText.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comment(_ sender: AnyObject) {
        
        let newComment = PostData(
            posterID: server.ref().authData.uid,
            posterFullName: userData["fullName"]!,
            postText: postText.text
        )
        
        server.broadcasts().child(byAppendingPath: thePostInfo.broadcastID + "/comments").childByAutoId().setValue(newComment.fbReadable())

        
        self.navigationController?.popViewController(animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //textView delegate functions & Properties
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // if the text color is gray, clear it, set black
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // if text is empty after editing, replace with placeholderasd
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }

    
    func setupTextView() {
        postText.textContainerInset.left = 8.0
        postText.textContainerInset.right = 8.0
        postText.textColor = UIColor.lightGray
        postText.isDirectionalLockEnabled = true
    }
    
    //code for textfield resizing on keyboard popup
    // http://bit.ly/1W1RZEO
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(NewComment.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func keyboardWasShown(_ aNotification:Notification) {
        let info = aNotification.userInfo
        let infoNSValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let kbSize = infoNSValue.cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 4, 0.0)
        postText.contentInset = contentInsets
        postText.scrollIndicatorInsets = contentInsets
    }
    
}
