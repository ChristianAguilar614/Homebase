//
//  PostData.swift
//  Homebase
//
//  Created by Justin Oroz on 10/14/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Foundation

class PostData{
    
    init(){
        
    }
    
    // Initializer (initialize all non-optionals)
    init(posterID:String ,posterFullName: String, postText: String) {
        // use self.varName if argument has the same name
        self.postText = postText
        self.posterID = posterID
        self.posterFullName = posterFullName
    }
    
    init(broadcastID: String, posterID:String ,posterFullName: String, postText: String) {
        // use self.varName if argument has the same name
        self.postText = postText
        self.posterID = posterID
        self.posterFullName = posterFullName
        self.broadcastID = broadcastID
    }
    
    //only let the variables be read after being set
    fileprivate(set) var postText:String = ""
    fileprivate(set) var posterID:String = ""
    fileprivate(set) var posterFullName:String = ""
    fileprivate(set) var broadcastID:String = ""
    
    func fbReadable() -> NSDictionary{
        //returns the information as readable by Firebase
        let data = [
            "text": self.postText,
            "uid": self.posterID,
            "fullName": self.posterFullName
        ]
        
        return data as NSDictionary
    }
}
