//
//  Comment.swift
//  Market
//
//  Created by MYMACBOOK on 1.05.2021.
//

import Foundation

struct Comment {
    var id: String
    var ownerId: String
    var itemId: String
    var comment: String
    var date: String
    
    init() {
        self.id = ""
        self.itemId = ""
        self.ownerId = ""
        self.date = ""
        self.comment = ""
    }
    
    init(dictionary: NSDictionary) {
        self.id = dictionary[kOBJECTID] as! String
        self.ownerId = dictionary[kOWNERID] as! String
        self.itemId = dictionary[kITEMID] as! String
        self.comment = dictionary[kCOMMENT] as! String
        self.date = dictionary[kDATE] as! String
    }
}
