//
//  GlobalFuncs.swift
//  Homebase
//
//  Created by Justin Oroz on 10/19/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayBasicAlert(_ title:String, error:String, buttonText: String) {
        let alertView = UIAlertController(title: title,
            message: error, preferredStyle:.alert)
        let okAction = UIAlertAction(title: buttonText, style: .default, handler: nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
}


