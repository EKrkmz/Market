//
//  Item.swift
//  Market
//
//  Created by MYMACBOOK on 27.04.2021.
//

import Foundation

struct Item {
    var id: String
    var categoryId: String?
    var name: String?
    var description: String?
    var price: Double?
    var imageLink: String?
    
    init() {
        self.id = ""
    }
    
    init(dictionary: NSDictionary) {
        self.id = dictionary[kOBJECTID] as! String
        self.categoryId = dictionary[kCATEGORYID] as? String
        self.name = dictionary[kNAME] as? String
        self.description = dictionary[kDESCRIPTION] as? String
        self.price = dictionary[kPRICE] as? Double
        self.imageLink = dictionary[kIMAGELINK] as? String
    }
}
