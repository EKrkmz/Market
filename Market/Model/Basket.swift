//
//  Basket.swift
//  Market
//
//  Created by MYMACBOOK on 29.04.2021.
//

import Foundation

struct Basket {
    var id: String
    var ownerId: String
    var itemIds: [String]!
    
    init() {
        self.id = ""
        self.ownerId = ""
    }
    
    init(_dictionary: NSDictionary) {
        self.id = _dictionary[kOBJECTID] as! String
        self.ownerId = _dictionary[kOWNERID] as! String
        self.itemIds = _dictionary[kITEMIDS] as? [String]
    }
}
