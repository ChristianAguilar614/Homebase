//
//  GlobalVar.swift
//  Homebase
//
//  Created by Justin Oroz on 10/19/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Foundation
import Firebase

struct urls { //Firebases objects of all frequently used URLS

    fileprivate let Server = "https://homebasehack.firebaseio.com"


    func ref() -> Firebase{ return Firebase(url: Server) }
    func bases() -> Firebase{ return ref().child(byAppendingPath: "bases") }
    func chats() -> Firebase{ return ref().child(byAppendingPath: "chats") }
    func users() -> Firebase{ return ref().child(byAppendingPath: "users") }
    
    func homebase() -> Firebase{
        let userData = UserDefaults.standard.value(forKey: "userData") as! Dictionary<String, String>
        return bases().child(byAppendingPath: userData["homebase"]!)
    }
    
    func broadcasts() -> Firebase{
        return homebase().child(byAppendingPath: "broadcasts")
    }
    
    func userData() -> Firebase{
        return users().child(byAppendingPath: ref().authData.uid)
    }
}

let server = urls()
